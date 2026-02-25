#!/usr/bin/env python3
"""
Manual 68000 disassembler for specific ROM regions of Aerobiz Supersonic.
Reads the ROM binary and decodes 68000 instructions to vasm-compatible mnemonics.

This does NOT use m68k_disasm.py (known bugs). Instead it implements
a focused subset of the 68000 instruction set decoder sufficient for the
target regions.

Architecture: Top-nibble dispatch (bits 15-12) then sub-dispatch.
"""

import struct
import sys

ROM_PATH = "/mnt/data/src/aerobiz-disasm/Aerobiz Supersonic (USA).gen"


def load_rom(path):
    with open(path, "rb") as f:
        return f.read()


# ─────────────────────────────────────────────
# Register names
# ─────────────────────────────────────────────

DATA_REGS = ["d0", "d1", "d2", "d3", "d4", "d5", "d6", "d7"]
ADDR_REGS = ["a0", "a1", "a2", "a3", "a4", "a5", "a6", "sp"]

def reg_d(n): return DATA_REGS[n & 7]
def reg_a(n): return ADDR_REGS[n & 7]


def sign_extend_byte(v):
    return v - 0x100 if v & 0x80 else v

def sign_extend_word(v):
    return v - 0x10000 if v & 0x8000 else v

def sign_extend_long(v):
    return v - 0x100000000 if v & 0x80000000 else v


SIZE_NAMES = {0: ".b", 1: ".w", 2: ".l"}


class Disassembler:
    def __init__(self, rom):
        self.rom = rom
        self.pc = 0

    def read_word(self):
        w = struct.unpack_from(">H", self.rom, self.pc)[0]
        self.pc += 2
        return w

    def read_long(self):
        val = struct.unpack_from(">I", self.rom, self.pc)[0]
        self.pc += 4
        return val

    # ─────────────────────────────────────────────
    # Effective Address decoder
    # ─────────────────────────────────────────────

    def decode_ea(self, mode, reg, size):
        """Decode an effective address field. Returns string representation.
        Reads extension words from ROM as needed (advancing self.pc)."""
        if mode == 0:  # Dn
            return reg_d(reg)
        if mode == 1:  # An
            return reg_a(reg)
        if mode == 2:  # (An)
            return f"({reg_a(reg)})"
        if mode == 3:  # (An)+
            return f"({reg_a(reg)})+"
        if mode == 4:  # -(An)
            return f"-({reg_a(reg)})"
        if mode == 5:  # d16(An)
            disp = sign_extend_word(self.read_word())
            return self._fmt_disp16(disp, reg_a(reg))
        if mode == 6:  # d8(An,Xn)
            return self._decode_brief_ext(reg_a(reg))
        if mode == 7:
            if reg == 0:  # abs.w
                addr = self.read_word()
                saddr = sign_extend_word(addr)
                if saddr < 0:
                    return f"($${addr:04x}).w"
                return f"($${addr:04x}).w"
            if reg == 1:  # abs.l
                addr = self.read_long()
                return f"${addr:08x}"
            if reg == 2:  # d16(PC)
                base_pc = self.pc
                disp = sign_extend_word(self.read_word())
                target = base_pc + disp
                return f"${target:06x}(pc)"
            if reg == 3:  # d8(PC,Xn)
                return self._decode_brief_ext("pc", is_pc=True)
            if reg == 4:  # #imm
                if size == 0:  # byte (word-aligned, high byte ignored)
                    val = self.read_word() & 0xFF
                    return f"#${val:02x}"
                elif size == 1:  # word
                    val = self.read_word()
                    return f"#${val:04x}"
                else:  # long
                    val = self.read_long()
                    return f"#${val:08x}"
        return f"<ea?m{mode}r{reg}>"

    def _decode_brief_ext(self, base_name, is_pc=False):
        """Decode brief extension word for indexed addressing."""
        if is_pc:
            base_pc = self.pc
        ext = self.read_word()
        d_a = (ext >> 15) & 1
        xreg = (ext >> 12) & 7
        wl = (ext >> 11) & 1
        disp8 = sign_extend_byte(ext & 0xFF)
        xn = reg_a(xreg) if d_a else reg_d(xreg)
        sz = ".l" if wl else ".w"
        if is_pc:
            target = base_pc + disp8
            return f"${target:06x}(pc,{xn}{sz})"
        if disp8 == 0:
            return f"({base_name},{xn}{sz})"
        if disp8 > 0:
            return f"${disp8:02x}({base_name},{xn}{sz})"
        return f"-${abs(disp8):02x}({base_name},{xn}{sz})"

    def _fmt_disp16(self, disp, base):
        """Format d16(An) or d16(PC) style."""
        if disp == 0:
            return f"({base})"
        if disp > 0:
            return f"${disp:04x}({base})"
        return f"-${abs(disp):04x}({base})"

    # ─────────────────────────────────────────────
    # MOVEM register list decoder
    # ─────────────────────────────────────────────

    def decode_movem_regs(self, mask, predecrement=False):
        if predecrement:
            # Bit 0 = a7, bit 7 = a0, bit 8 = d7, bit 15 = d0
            bits = []
            for i in range(16):
                if mask & (1 << i):
                    bits.append(15 - i)
            # bits now has register numbers 0-15 (0-7=d0-d7, 8-15=a0-a7)
        else:
            bits = []
            for i in range(16):
                if mask & (1 << i):
                    bits.append(i)

        dregs = sorted([b for b in bits if b < 8])
        aregs = sorted([b - 8 for b in bits if b >= 8])

        parts = []
        parts.extend(self._compress_range(dregs, "d"))
        parts.extend(self._compress_range(aregs, "a"))
        return "/".join(parts)

    def _compress_range(self, nums, prefix):
        if not nums:
            return []
        parts = []
        i = 0
        while i < len(nums):
            start = nums[i]
            end = start
            while i + 1 < len(nums) and nums[i + 1] == end + 1:
                i += 1
                end = nums[i]
            sn = "sp" if prefix == "a" and start == 7 else f"{prefix}{start}"
            en = "sp" if prefix == "a" and end == 7 else f"{prefix}{end}"
            if start == end:
                parts.append(sn)
            else:
                parts.append(f"{sn}-{en}")
            i += 1
        return parts

    # ─────────────────────────────────────────────
    # Main instruction decoder
    # ─────────────────────────────────────────────

    def disassemble_one(self):
        """Decode one instruction. Returns (start_addr, mnemonic_str, byte_count)."""
        start_pc = self.pc
        opword = self.read_word()
        top = (opword >> 12) & 0xF

        # Dispatch by top nibble
        try:
            if top == 0x0:
                result = self._decode_line0(opword, start_pc)
            elif top in (0x1, 0x2, 0x3):
                result = self._decode_move(opword, start_pc)
            elif top == 0x4:
                result = self._decode_line4(opword, start_pc)
            elif top == 0x5:
                result = self._decode_line5(opword, start_pc)
            elif top == 0x6:
                result = self._decode_line6(opword, start_pc)
            elif top == 0x7:
                result = self._decode_moveq(opword, start_pc)
            elif top == 0x8:
                result = self._decode_line8(opword, start_pc)
            elif top == 0x9:
                result = self._decode_addsub(opword, start_pc, "sub")
            elif top == 0xA:
                result = self._decode_lineA(opword, start_pc)
            elif top == 0xB:
                result = self._decode_lineB(opword, start_pc)
            elif top == 0xC:
                result = self._decode_lineC(opword, start_pc)
            elif top == 0xD:
                result = self._decode_addsub(opword, start_pc, "add")
            elif top == 0xE:
                result = self._decode_shift(opword, start_pc)
            else:  # 0xF
                result = self._decode_lineF(opword, start_pc)

            if result is not None:
                return result
        except Exception:
            pass

        # Fallback
        self.pc = start_pc + 2
        return start_pc, f"dc.w ${opword:04x}", 2

    # ─────────────────────────────────────────────
    # Line 0: ORI, ANDI, SUBI, ADDI, EORI, CMPI, BTST/BCHG/BCLR/BSET
    # ─────────────────────────────────────────────

    def _decode_line0(self, opword, start_pc):
        # Bit manipulation with immediate: 0000 1000 xx ea
        bits_11_8 = (opword >> 8) & 0xF

        # ORI to CCR: $003C
        if opword == 0x003C:
            imm = self.read_word() & 0xFF
            return start_pc, f"ori #${imm:02x},ccr", self.pc - start_pc
        # ORI to SR: $007C
        if opword == 0x007C:
            imm = self.read_word()
            return start_pc, f"ori #${imm:04x},sr", self.pc - start_pc
        # ANDI to CCR: $023C
        if opword == 0x023C:
            imm = self.read_word() & 0xFF
            return start_pc, f"andi #${imm:02x},ccr", self.pc - start_pc
        # ANDI to SR: $027C
        if opword == 0x027C:
            imm = self.read_word()
            return start_pc, f"andi #${imm:04x},sr", self.pc - start_pc
        # EORI to CCR: $0A3C
        if opword == 0x0A3C:
            imm = self.read_word() & 0xFF
            return start_pc, f"eori #${imm:02x},ccr", self.pc - start_pc
        # EORI to SR: $0A7C
        if opword == 0x0A7C:
            imm = self.read_word()
            return start_pc, f"eori #${imm:04x},sr", self.pc - start_pc

        # Immediate operations: ORI, ANDI, SUBI, ADDI, EORI, CMPI
        imm_ops = {0: "ori", 2: "andi", 4: "subi", 6: "addi", 0xA: "eori", 0xC: "cmpi"}
        op_id = (opword >> 8) & 0xF
        if op_id in imm_ops and ((opword >> 6) & 3) != 3:
            name = imm_ops[op_id]
            sz = (opword >> 6) & 3
            mode = (opword >> 3) & 7
            reg = opword & 7
            if sz == 0:
                imm = self.read_word() & 0xFF
                immstr = f"#${imm:02x}"
            elif sz == 1:
                imm = self.read_word()
                immstr = f"#${imm:04x}"
            else:
                imm = self.read_long()
                immstr = f"#${imm:08x}"
            ea = self.decode_ea(mode, reg, sz)
            return start_pc, f"{name}{SIZE_NAMES[sz]} {immstr},{ea}", self.pc - start_pc

        # Static bit operations (immediate bit number): 0000 100 0xx ea
        if (opword & 0xFF00) == 0x0800:
            typ = (opword >> 6) & 3
            mode = (opword >> 3) & 7
            reg = opword & 7
            bitnum = self.read_word() & 0xFF  # bit number in extension word
            ea = self.decode_ea(mode, reg, 0)
            names = {0: "btst", 1: "bchg", 2: "bclr", 3: "bset"}
            return start_pc, f"{names[typ]} #{bitnum},{ea}", self.pc - start_pc

        # Dynamic bit operations (register bit number): 0000 ddd 1xx ea
        if (opword >> 8) & 1 == 1 and (opword >> 6) & 3 != 3:
            dn = (opword >> 9) & 7
            typ = (opword >> 6) & 3
            mode = (opword >> 3) & 7
            reg = opword & 7
            ea = self.decode_ea(mode, reg, 0)
            names = {0: "btst", 1: "bchg", 2: "bclr", 3: "bset"}
            return start_pc, f"{names[typ]} {reg_d(dn)},{ea}", self.pc - start_pc

        # MOVEP: 0000 ddd 1mm 001 aaa (mode 4-7, reg field ea mode = 1)
        if (opword & 0x0138) == 0x0108:
            dn = (opword >> 9) & 7
            an = opword & 7
            opmode = (opword >> 6) & 7
            disp = sign_extend_word(self.read_word())
            disp_str = self._fmt_disp16(disp, reg_a(an))
            if opmode == 4:
                return start_pc, f"movep.w {disp_str},{reg_d(dn)}", self.pc - start_pc
            elif opmode == 5:
                return start_pc, f"movep.l {disp_str},{reg_d(dn)}", self.pc - start_pc
            elif opmode == 6:
                return start_pc, f"movep.w {reg_d(dn)},{disp_str}", self.pc - start_pc
            elif opmode == 7:
                return start_pc, f"movep.l {reg_d(dn)},{disp_str}", self.pc - start_pc

        return None

    # ─────────────────────────────────────────────
    # MOVE/MOVEA: top nibbles 1, 2, 3
    # ─────────────────────────────────────────────

    def _decode_move(self, opword, start_pc):
        top = (opword >> 12) & 3
        # Size: 01=.b, 11=.w, 10=.l
        sz_map = {1: 0, 3: 1, 2: 2}
        sz = sz_map.get(top)
        if sz is None:
            return None

        src_mode = (opword >> 3) & 7
        src_reg = opword & 7
        dst_reg = (opword >> 9) & 7
        dst_mode = (opword >> 6) & 7

        # Decode source EA
        src_ea = self.decode_ea(src_mode, src_reg, sz)

        # MOVEA (destination mode 1 = address register)
        if dst_mode == 1:
            # MOVEA only valid for .w and .l
            sz_name = ".l" if sz == 2 else ".w"
            return start_pc, f"movea{sz_name} {src_ea},{reg_a(dst_reg)}", self.pc - start_pc

        # Regular MOVE
        dst_ea = self.decode_ea(dst_mode, dst_reg, sz)
        return start_pc, f"move{SIZE_NAMES[sz]} {src_ea},{dst_ea}", self.pc - start_pc

    # ─────────────────────────────────────────────
    # Line 4: Miscellaneous (CLR, TST, NEG, NOT, JSR, JMP, LEA, PEA, MOVEM, etc.)
    # ─────────────────────────────────────────────

    def _decode_line4(self, opword, start_pc):
        # Quick checks for fixed opcodes
        if opword == 0x4E71: return start_pc, "nop", 2
        if opword == 0x4E75: return start_pc, "rts", 2
        if opword == 0x4E73: return start_pc, "rte", 2
        if opword == 0x4E77: return start_pc, "rtr", 2
        if opword == 0x4E70: return start_pc, "reset", 2
        if opword == 0x4AFC: return start_pc, "illegal", 2
        if opword == 0x4E72:
            imm = self.read_word()
            return start_pc, f"stop #${imm:04x}", self.pc - start_pc

        # TRAP #n: 0100 1110 0100 nnnn
        if (opword & 0xFFF0) == 0x4E40:
            return start_pc, f"trap #{opword & 0xF}", self.pc - start_pc

        # LINK: 0100 1110 0101 0 aaa
        if (opword & 0xFFF8) == 0x4E50:
            an = opword & 7
            disp = sign_extend_word(self.read_word())
            if disp >= 0:
                return start_pc, f"link {reg_a(an)},#${disp:04x}", self.pc - start_pc
            return start_pc, f"link {reg_a(an)},#-${abs(disp):04x}", self.pc - start_pc

        # UNLK: 0100 1110 0101 1 aaa
        if (opword & 0xFFF8) == 0x4E58:
            return start_pc, f"unlk {reg_a(opword & 7)}", self.pc - start_pc

        # MOVE USP: 0100 1110 0110 xddd
        if (opword & 0xFFF0) == 0x4E60:
            dr = (opword >> 3) & 1
            an = opword & 7
            if dr == 0:
                return start_pc, f"move {reg_a(an)},usp", 2
            return start_pc, f"move usp,{reg_a(an)}", 2

        # MOVE to SR: 0100 0110 11 ea  ($46C0-$46FF)
        if (opword & 0xFFC0) == 0x46C0:
            mode = (opword >> 3) & 7
            reg = opword & 7
            ea = self.decode_ea(mode, reg, 1)
            return start_pc, f"move {ea},sr", self.pc - start_pc

        # MOVE from SR: 0100 0000 11 ea  ($40C0-$40FF)
        if (opword & 0xFFC0) == 0x40C0:
            mode = (opword >> 3) & 7
            reg = opword & 7
            ea = self.decode_ea(mode, reg, 1)
            return start_pc, f"move sr,{ea}", self.pc - start_pc

        # MOVE to CCR: 0100 0100 11 ea  ($44C0-$44FF)
        if (opword & 0xFFC0) == 0x44C0:
            mode = (opword >> 3) & 7
            reg = opword & 7
            ea = self.decode_ea(mode, reg, 1)
            return start_pc, f"move {ea},ccr", self.pc - start_pc

        # JMP: 0100 1110 11 ea  ($4EC0-$4EFF)
        if (opword & 0xFFC0) == 0x4EC0:
            mode = (opword >> 3) & 7
            reg = opword & 7
            ea = self.decode_ea(mode, reg, 2)
            return start_pc, f"jmp {ea}", self.pc - start_pc

        # JSR: 0100 1110 10 ea  ($4E80-$4EBF)
        if (opword & 0xFFC0) == 0x4E80:
            mode = (opword >> 3) & 7
            reg = opword & 7
            ea = self.decode_ea(mode, reg, 2)
            return start_pc, f"jsr {ea}", self.pc - start_pc

        # LEA: 0100 aaa 111 ea
        if (opword & 0xF1C0) == 0x41C0:
            an = (opword >> 9) & 7
            mode = (opword >> 3) & 7
            reg = opword & 7
            ea = self.decode_ea(mode, reg, 2)
            return start_pc, f"lea {ea},{reg_a(an)}", self.pc - start_pc

        # PEA: 0100 1000 01 ea
        if (opword & 0xFFC0) == 0x4840:
            mode = (opword >> 3) & 7
            reg = opword & 7
            # But SWAP is 0100 1000 0100 0ddd -> 0x4840-0x4847 with mode=0
            if mode == 0:
                return start_pc, f"swap {reg_d(reg)}", 2
            ea = self.decode_ea(mode, reg, 2)
            return start_pc, f"pea {ea}", self.pc - start_pc

        # CLR: 0100 0010 ss ea
        if (opword & 0xFF00) == 0x4200:
            sz = (opword >> 6) & 3
            if sz < 3:
                mode = (opword >> 3) & 7
                reg = opword & 7
                ea = self.decode_ea(mode, reg, sz)
                return start_pc, f"clr{SIZE_NAMES[sz]} {ea}", self.pc - start_pc

        # NEG: 0100 0100 ss ea (but ss=3 -> MOVE to CCR, handled above)
        if (opword & 0xFF00) == 0x4400 and ((opword >> 6) & 3) != 3:
            sz = (opword >> 6) & 3
            mode = (opword >> 3) & 7
            reg = opword & 7
            ea = self.decode_ea(mode, reg, sz)
            return start_pc, f"neg{SIZE_NAMES[sz]} {ea}", self.pc - start_pc

        # NEGX: 0100 0000 ss ea (but ss=3 -> MOVE from SR)
        if (opword & 0xFF00) == 0x4000 and ((opword >> 6) & 3) != 3:
            sz = (opword >> 6) & 3
            mode = (opword >> 3) & 7
            reg = opword & 7
            ea = self.decode_ea(mode, reg, sz)
            return start_pc, f"negx{SIZE_NAMES[sz]} {ea}", self.pc - start_pc

        # NOT: 0100 0110 ss ea (but ss=3 -> MOVE to SR)
        if (opword & 0xFF00) == 0x4600 and ((opword >> 6) & 3) != 3:
            sz = (opword >> 6) & 3
            mode = (opword >> 3) & 7
            reg = opword & 7
            ea = self.decode_ea(mode, reg, sz)
            return start_pc, f"not{SIZE_NAMES[sz]} {ea}", self.pc - start_pc

        # TST: 0100 1010 ss ea
        if (opword & 0xFF00) == 0x4A00:
            sz = (opword >> 6) & 3
            if sz < 3:
                mode = (opword >> 3) & 7
                reg = opword & 7
                ea = self.decode_ea(mode, reg, sz)
                return start_pc, f"tst{SIZE_NAMES[sz]} {ea}", self.pc - start_pc
            else:
                # TAS: 0100 1010 11 ea
                mode = (opword >> 3) & 7
                reg = opword & 7
                ea = self.decode_ea(mode, reg, 0)
                return start_pc, f"tas {ea}", self.pc - start_pc

        # EXT: 0100 100 opm 000 Dn
        if (opword & 0xFB8) == 0x880 and ((opword >> 12) == 4):
            # More precise: 0100 1000 1x00 0ddd
            if (opword & 0xFE38) == 0x4800:
                # Careful: 0100 1000 1000 0ddd = EXT.W Dn ($4880-$4887)
                # 0100 1000 1100 0ddd = EXT.L Dn ($48C0-$48C7)
                dn = opword & 7
                if (opword & 0x01C0) == 0x0080:
                    return start_pc, f"ext.w {reg_d(dn)}", 2
                elif (opword & 0x01C0) == 0x00C0:
                    return start_pc, f"ext.l {reg_d(dn)}", 2

        # MOVEM register to memory: 0100 1000 1s ea (s: 0=.w, 1=.l)
        if (opword & 0xFF80) == 0x4880:
            sz = ".w" if (opword & 0x0040) == 0 else ".l"
            mode = (opword >> 3) & 7
            reg = opword & 7
            # Skip if mode=0 (that's EXT, handled above... but check)
            if mode == 0:
                # This is EXT, already handled
                pass
            else:
                mask = self.read_word()
                if mode == 4:  # -(An)
                    reglist = self.decode_movem_regs(mask, predecrement=True)
                    return start_pc, f"movem{sz} {reglist},-({reg_a(reg)})", self.pc - start_pc
                else:
                    ea = self.decode_ea(mode, reg, 2)
                    reglist = self.decode_movem_regs(mask, predecrement=False)
                    return start_pc, f"movem{sz} {reglist},{ea}", self.pc - start_pc

        # MOVEM memory to register: 0100 1100 1s ea
        if (opword & 0xFF80) == 0x4C80:
            sz = ".w" if (opword & 0x0040) == 0 else ".l"
            mode = (opword >> 3) & 7
            reg = opword & 7
            mask = self.read_word()
            reglist = self.decode_movem_regs(mask, predecrement=False)
            if mode == 3:  # (An)+
                return start_pc, f"movem{sz} ({reg_a(reg)})+,{reglist}", self.pc - start_pc
            else:
                ea = self.decode_ea(mode, reg, 2)
                return start_pc, f"movem{sz} {ea},{reglist}", self.pc - start_pc

        return None

    # ─────────────────────────────────────────────
    # Line 5: ADDQ/SUBQ/Scc/DBcc
    # ─────────────────────────────────────────────

    def _decode_line5(self, opword, start_pc):
        sz = (opword >> 6) & 3

        if sz == 3:
            # Scc or DBcc
            mode = (opword >> 3) & 7
            reg = opword & 7
            cond = (opword >> 8) & 0xF

            if mode == 1:
                # DBcc
                cond_names = {
                    0: "dbt", 1: "dbra", 2: "dbhi", 3: "dbls",
                    4: "dbcc", 5: "dbcs", 6: "dbne", 7: "dbeq",
                    8: "dbvc", 9: "dbvs", 10: "dbpl", 11: "dbmi",
                    12: "dbge", 13: "dblt", 14: "dbgt", 15: "dble"
                }
                disp_pc = self.pc
                disp = sign_extend_word(self.read_word())
                target = disp_pc + disp
                return start_pc, f"{cond_names[cond]} {reg_d(reg)},${target:06x}", self.pc - start_pc

            # Scc
            scc_names = {
                0: "st", 1: "sf", 2: "shi", 3: "sls",
                4: "scc", 5: "scs", 6: "sne", 7: "seq",
                8: "svc", 9: "svs", 10: "spl", 11: "smi",
                12: "sge", 13: "slt", 14: "sgt", 15: "sle"
            }
            ea = self.decode_ea(mode, reg, 0)
            return start_pc, f"{scc_names[cond]} {ea}", self.pc - start_pc

        # ADDQ/SUBQ
        data = (opword >> 9) & 7
        if data == 0: data = 8
        direction = (opword >> 8) & 1  # 0 = ADDQ, 1 = SUBQ
        mode = (opword >> 3) & 7
        reg = opword & 7
        name = "subq" if direction else "addq"
        ea = self.decode_ea(mode, reg, sz)
        return start_pc, f"{name}{SIZE_NAMES[sz]} #{data},{ea}", self.pc - start_pc

    # ─────────────────────────────────────────────
    # Line 6: Bcc/BRA/BSR
    # ─────────────────────────────────────────────

    def _decode_line6(self, opword, start_pc):
        cond = (opword >> 8) & 0xF
        disp8 = opword & 0xFF

        cond_names = {
            0: "bra", 1: "bsr", 2: "bhi", 3: "bls",
            4: "bcc", 5: "bcs", 6: "bne", 7: "beq",
            8: "bvc", 9: "bvs", 10: "bpl", 11: "bmi",
            12: "bge", 13: "blt", 14: "bgt", 15: "ble"
        }
        name = cond_names[cond]

        if disp8 == 0x00:
            # Word displacement
            disp16 = sign_extend_word(self.read_word())
            target = start_pc + 2 + disp16
            return start_pc, f"{name}.w ${target:06x}", self.pc - start_pc
        elif disp8 == 0xFF:
            # Long displacement (68020+)
            disp32 = self.read_long()
            target = start_pc + 2 + sign_extend_long(disp32)
            return start_pc, f"{name}.l ${target:06x}", self.pc - start_pc
        else:
            disp = sign_extend_byte(disp8)
            target = start_pc + 2 + disp
            return start_pc, f"{name}.s ${target:06x}", self.pc - start_pc

    # ─────────────────────────────────────────────
    # Line 7: MOVEQ
    # ─────────────────────────────────────────────

    def _decode_moveq(self, opword, start_pc):
        if opword & 0x0100:
            return None  # Not MOVEQ (bit 8 must be 0)
        dn = (opword >> 9) & 7
        imm8 = sign_extend_byte(opword & 0xFF)
        if imm8 < 0:
            return start_pc, f"moveq #-{abs(imm8)},{reg_d(dn)}", 2
        return start_pc, f"moveq #{imm8},{reg_d(dn)}", 2

    # ─────────────────────────────────────────────
    # Line 8: OR/DIVU/DIVS/SBCD
    # ─────────────────────────────────────────────

    def _decode_line8(self, opword, start_pc):
        dn = (opword >> 9) & 7
        opmode = (opword >> 6) & 7
        mode = (opword >> 3) & 7
        reg = opword & 7

        # DIVU: opmode 3
        if opmode == 3:
            ea = self.decode_ea(mode, reg, 1)
            return start_pc, f"divu.w {ea},{reg_d(dn)}", self.pc - start_pc

        # DIVS: opmode 7
        if opmode == 7:
            ea = self.decode_ea(mode, reg, 1)
            return start_pc, f"divs.w {ea},{reg_d(dn)}", self.pc - start_pc

        # SBCD: opmode 4, mode 0 or 1
        if opmode == 4 and mode in (0, 1):
            rm = (opword >> 3) & 1
            ry = opword & 7
            if rm == 0:
                return start_pc, f"sbcd {reg_d(ry)},{reg_d(dn)}", 2
            return start_pc, f"sbcd -({reg_a(ry)}),-({reg_a(dn)})", 2

        # OR ea,Dn (opmode 0,1,2)
        if opmode < 3:
            ea = self.decode_ea(mode, reg, opmode)
            return start_pc, f"or{SIZE_NAMES[opmode]} {ea},{reg_d(dn)}", self.pc - start_pc

        # OR Dn,ea (opmode 4,5,6)
        if opmode in (4, 5, 6):
            sz = opmode - 4
            ea = self.decode_ea(mode, reg, sz)
            return start_pc, f"or{SIZE_NAMES[sz]} {reg_d(dn)},{ea}", self.pc - start_pc

        return None

    # ─────────────────────────────────────────────
    # Line 9/D: ADD/SUB/ADDA/SUBA/ADDX/SUBX
    # ─────────────────────────────────────────────

    def _decode_addsub(self, opword, start_pc, name):
        dn = (opword >> 9) & 7
        opmode = (opword >> 6) & 7
        mode = (opword >> 3) & 7
        reg = opword & 7

        # ADDA/SUBA
        if opmode == 3:
            ea = self.decode_ea(mode, reg, 1)
            return start_pc, f"{name}a.w {ea},{reg_a(dn)}", self.pc - start_pc
        if opmode == 7:
            ea = self.decode_ea(mode, reg, 2)
            return start_pc, f"{name}a.l {ea},{reg_a(dn)}", self.pc - start_pc

        # ADDX/SUBX: opmode 4,5,6 with rm bit (bit 3)
        if opmode in (4, 5, 6):
            rm = (opword >> 3) & 1
            if rm == 0 and mode == 0:
                # Dn,Dn
                sz = opmode - 4
                return start_pc, f"{name}x{SIZE_NAMES[sz]} {reg_d(reg)},{reg_d(dn)}", 2
            if rm == 1 and mode == 1:
                # -(An),-(An)
                sz = opmode - 4
                return start_pc, f"{name}x{SIZE_NAMES[sz]} -({reg_a(reg)}),-({reg_a(dn)})", 2
            # Regular ADD/SUB Dn,<ea>
            sz = opmode - 4
            ea = self.decode_ea(mode, reg, sz)
            return start_pc, f"{name}{SIZE_NAMES[sz]} {reg_d(dn)},{ea}", self.pc - start_pc

        # ea,Dn
        if opmode < 3:
            ea = self.decode_ea(mode, reg, opmode)
            return start_pc, f"{name}{SIZE_NAMES[opmode]} {ea},{reg_d(dn)}", self.pc - start_pc

        return None

    # ─────────────────────────────────────────────
    # Line A: Unassigned (Line-A emulator)
    # ─────────────────────────────────────────────

    def _decode_lineA(self, opword, start_pc):
        return start_pc, f"dc.w ${opword:04x}  ; line-A", 2

    # ─────────────────────────────────────────────
    # Line B: CMP/CMPA/CMPM/EOR
    # ─────────────────────────────────────────────

    def _decode_lineB(self, opword, start_pc):
        dn = (opword >> 9) & 7
        opmode = (opword >> 6) & 7
        mode = (opword >> 3) & 7
        reg = opword & 7

        # CMPA.W
        if opmode == 3:
            ea = self.decode_ea(mode, reg, 1)
            return start_pc, f"cmpa.w {ea},{reg_a(dn)}", self.pc - start_pc
        # CMPA.L
        if opmode == 7:
            ea = self.decode_ea(mode, reg, 2)
            return start_pc, f"cmpa.l {ea},{reg_a(dn)}", self.pc - start_pc

        # CMP ea,Dn (opmode 0,1,2)
        if opmode < 3:
            ea = self.decode_ea(mode, reg, opmode)
            return start_pc, f"cmp{SIZE_NAMES[opmode]} {ea},{reg_d(dn)}", self.pc - start_pc

        # EOR/CMPM (opmode 4,5,6)
        if opmode in (4, 5, 6):
            sz = opmode - 4
            if mode == 1:
                # CMPM (An)+,(An)+
                return start_pc, f"cmpm{SIZE_NAMES[sz]} ({reg_a(reg)})+,({reg_a(dn)})+", 2
            # EOR Dn,ea
            ea = self.decode_ea(mode, reg, sz)
            return start_pc, f"eor{SIZE_NAMES[sz]} {reg_d(dn)},{ea}", self.pc - start_pc

        return None

    # ─────────────────────────────────────────────
    # Line C: AND/MULU/MULS/ABCD/EXG
    # ─────────────────────────────────────────────

    def _decode_lineC(self, opword, start_pc):
        dn = (opword >> 9) & 7
        opmode = (opword >> 6) & 7
        mode = (opword >> 3) & 7
        reg = opword & 7

        # MULU
        if opmode == 3:
            ea = self.decode_ea(mode, reg, 1)
            return start_pc, f"mulu.w {ea},{reg_d(dn)}", self.pc - start_pc
        # MULS
        if opmode == 7:
            ea = self.decode_ea(mode, reg, 1)
            return start_pc, f"muls.w {ea},{reg_d(dn)}", self.pc - start_pc

        # EXG: opmode 4 or 5 or 6 with specific mode bits
        # EXG Dx,Dy: 1100 xxx 1 01000 yyy
        if (opword & 0xF1F8) == 0xC140:
            return start_pc, f"exg {reg_d(dn)},{reg_d(reg)}", 2
        # EXG Ax,Ay: 1100 xxx 1 01001 yyy
        if (opword & 0xF1F8) == 0xC148:
            return start_pc, f"exg {reg_a(dn)},{reg_a(reg)}", 2
        # EXG Dx,Ay: 1100 xxx 1 10001 yyy
        if (opword & 0xF1F8) == 0xC188:
            return start_pc, f"exg {reg_d(dn)},{reg_a(reg)}", 2

        # ABCD: opmode 4, rm=0 -> Dx,Dy; rm=1 -> -(Ax),-(Ay)
        if opmode == 4 and mode in (0, 1):
            rm = (opword >> 3) & 1
            ry = opword & 7
            if rm == 0:
                return start_pc, f"abcd {reg_d(ry)},{reg_d(dn)}", 2
            return start_pc, f"abcd -({reg_a(ry)}),-({reg_a(dn)})", 2

        # AND ea,Dn (opmode 0,1,2)
        if opmode < 3:
            ea = self.decode_ea(mode, reg, opmode)
            return start_pc, f"and{SIZE_NAMES[opmode]} {ea},{reg_d(dn)}", self.pc - start_pc

        # AND Dn,ea (opmode 4,5,6)
        if opmode in (4, 5, 6):
            sz = opmode - 4
            ea = self.decode_ea(mode, reg, sz)
            return start_pc, f"and{SIZE_NAMES[sz]} {reg_d(dn)},{ea}", self.pc - start_pc

        return None

    # ─────────────────────────────────────────────
    # Line E: Shifts and Rotates
    # ─────────────────────────────────────────────

    def _decode_shift(self, opword, start_pc):
        sz = (opword >> 6) & 3

        if sz == 3:
            # Memory shift (1 bit): 1110 0tt d11 ea
            typ = (opword >> 9) & 3
            dr = (opword >> 8) & 1
            mode = (opword >> 3) & 7
            reg = opword & 7
            names = ["as", "ls", "rox", "ro"]
            dirch = "l" if dr else "r"
            ea = self.decode_ea(mode, reg, 1)
            return start_pc, f"{names[typ]}{dirch}.w {ea}", self.pc - start_pc

        # Register/immediate shifts
        count_reg = (opword >> 9) & 7
        dr = (opword >> 8) & 1
        ir = (opword >> 5) & 1
        typ = (opword >> 3) & 3
        dn = opword & 7

        names = ["as", "ls", "rox", "ro"]
        dirch = "l" if dr else "r"

        if ir == 0:
            cnt = count_reg if count_reg != 0 else 8
            return start_pc, f"{names[typ]}{dirch}{SIZE_NAMES[sz]} #{cnt},{reg_d(dn)}", 2
        return start_pc, f"{names[typ]}{dirch}{SIZE_NAMES[sz]} {reg_d(count_reg)},{reg_d(dn)}", 2

    # ─────────────────────────────────────────────
    # Line F: Coprocessor / unassigned
    # ─────────────────────────────────────────────

    def _decode_lineF(self, opword, start_pc):
        return start_pc, f"dc.w ${opword:04x}  ; line-F", 2

    # ─────────────────────────────────────────────
    # Region disassembly
    # ─────────────────────────────────────────────

    def disassemble_region(self, start, end):
        self.pc = start
        results = []
        while self.pc < end:
            addr_before = self.pc
            addr, mnemonic, nbytes = self.disassemble_one()
            raw = self.rom[addr_before:addr_before + nbytes]
            raw_hex = " ".join(f"{raw[i]:02x}{raw[i+1]:02x}" for i in range(0, len(raw), 2))
            results.append((addr, mnemonic, raw_hex, nbytes))
        return results


def print_region(rom, name, start, end, data_ranges=None):
    """Disassemble and print a ROM region.
    data_ranges: list of (start, end) tuples marking inline data that should
    be printed as dc.w/dc.b/dc.l instead of disassembled.
    """
    if data_ranges is None:
        data_ranges = []

    d = Disassembler(rom)

    print(f"\n{'='*78}")
    print(f"  {name}")
    print(f"  Address range: ${start:06x}-${end:06x} ({end - start} bytes)")
    print(f"{'='*78}")

    # Raw hex dump
    print(f"\n--- Raw hex words ---")
    for off in range(start, end, 16):
        chunk_end = min(off + 16, end)
        words = []
        for w_off in range(off, chunk_end, 2):
            w = struct.unpack_from(">H", rom, w_off)[0]
            words.append(f"${w:04x}")
        print(f"  ${off:06x}: {', '.join(words)}")

    # Disassembly
    print(f"\n--- Disassembly (vasm syntax) ---")

    # Merge code and data ranges
    # Sort data ranges
    data_ranges = sorted(data_ranges)

    pos = start
    for dr_start, dr_end, dr_label in data_ranges:
        # Disassemble code before this data range
        if pos < dr_start:
            results = d.disassemble_region(pos, dr_start)
            for addr, mnemonic, raw_hex, nbytes in results:
                print(f"  ${addr:06x}:  {raw_hex:<28s}  {mnemonic}")

        # Print data range
        if dr_label:
            print(f"  ; --- {dr_label} ---")
        for doff in range(dr_start, dr_end, 2):
            w = struct.unpack_from(">H", rom, doff)[0]
            print(f"  ${doff:06x}:  {w:02x}{w >> 8 & 0xff:02x}                          dc.w ${w:04x}")
        pos = dr_end
        d.pc = dr_end

    # Disassemble remaining code
    if pos < end:
        results = d.disassemble_region(pos, end)
        for addr, mnemonic, raw_hex, nbytes in results:
            print(f"  ${addr:06x}:  {raw_hex:<28s}  {mnemonic}")

    print()


def print_region_simple(rom, name, start, end):
    """Simple disassembly with no data ranges."""
    d = Disassembler(rom)

    print(f"\n{'='*78}")
    print(f"  {name}")
    print(f"  Address range: ${start:06x}-${end:06x} ({end - start} bytes)")
    print(f"{'='*78}")

    print(f"\n--- Raw hex words ---")
    for off in range(start, end, 16):
        chunk_end = min(off + 16, end)
        words = []
        for w_off in range(off, chunk_end, 2):
            w = struct.unpack_from(">H", rom, w_off)[0]
            words.append(f"${w:04x}")
        print(f"  ${off:06x}: {', '.join(words)}")

    print(f"\n--- Disassembly (vasm syntax) ---")
    results = d.disassemble_region(start, end)
    for addr, mnemonic, raw_hex, nbytes in results:
        print(f"  ${addr:06x}:  {raw_hex:<28s}  {mnemonic}")
    print()
    return results


def print_annotated_region(rom, name, start, end, annotations=None, data_ranges=None):
    """Disassemble a region with inline annotations and data range markers.
    annotations: dict of {addr: "comment"} for inline comments
    data_ranges: list of (start, end, label) for inline data blocks
    """
    if annotations is None:
        annotations = {}
    if data_ranges is None:
        data_ranges = []

    d = Disassembler(rom)

    print(f"\n{'='*78}")
    print(f"  {name}")
    print(f"  Address range: ${start:06x}-${end:06x} ({end - start} bytes)")
    print(f"{'='*78}")

    # Raw hex dump
    print(f"\n--- Raw hex words ---")
    for off in range(start, end, 16):
        chunk_end = min(off + 16, end)
        words = []
        for w_off in range(off, chunk_end, 2):
            w = struct.unpack_from(">H", rom, w_off)[0]
            words.append(f"${w:04x}")
        print(f"  ${off:06x}: {', '.join(words)}")

    # Disassembly with annotations
    print(f"\n--- Disassembly (vasm syntax) ---")

    data_set = set()
    for dr_start, dr_end, dr_label in data_ranges:
        for a in range(dr_start, dr_end):
            data_set.add(a)

    d.pc = start
    while d.pc < end:
        # Check if we're in a data range
        if d.pc in data_set:
            # Find the data range we're in
            for dr_start, dr_end, dr_label in data_ranges:
                if d.pc == dr_start:
                    print(f"\n  ; --- {dr_label} ---")
                    break
            # Print as dc.w
            w = struct.unpack_from(">H", rom, d.pc)[0]
            addr = d.pc
            comment = annotations.get(addr, "")
            if comment:
                print(f"  ${addr:06x}:  {w:04x}                          dc.w ${w:04x}  ; {comment}")
            else:
                print(f"  ${addr:06x}:  {w:04x}                          dc.w ${w:04x}")
            d.pc += 2
            continue

        # Check for annotation before disassembly
        pre_comment = annotations.get(d.pc)
        addr_before = d.pc
        addr, mnemonic, nbytes = d.disassemble_one()
        raw = rom[addr_before:addr_before + nbytes]
        raw_hex = " ".join(f"{raw[i]:02x}{raw[i+1]:02x}" for i in range(0, len(raw), 2))

        comment = annotations.get(addr, "")
        if comment:
            print(f"  ${addr:06x}:  {raw_hex:<28s}  {mnemonic:<36s}  ; {comment}")
        else:
            print(f"  ${addr:06x}:  {raw_hex:<28s}  {mnemonic}")

    print()


def main():
    rom = load_rom(ROM_PATH)
    print(f"ROM loaded: {len(rom)} bytes ({len(rom) / 1024:.0f} KB)")

    # ═══════════════════════════════════════════════════════════════
    # Region 1: Exception Handlers
    # ═══════════════════════════════════════════════════════════════
    r1_annot = {
        0x000F84: "Bus Error handler (vector 2)",
        0x000F8A: "Address Error handler (vector 3)",
        0x000F90: "Illegal Instruction handler (vector 4)",
        0x000F96: "Zero Divide handler (vector 5)",
        0x000F9C: "CHK handler (vector 6)",
        0x000FA2: "TRAPV handler (vector 7)",
        0x000FA8: "Privilege Violation handler (vector 8)",
        0x000FAE: "Trace handler (vector 9)",
        0x000FB4: "Line-A Emulator handler (vector 10)",
        0x000FBA: "Line-F Emulator handler (vector 11)",
        0x000FC0: "Reserved handler (vector 12)",
        0x000FC6: "Reserved handler (vector 13)",
        0x000FCC: "Reserved handler (vector 14)",
        0x000FD2: "Uninitialized Interrupt handler (vector 15)",
        0x000FD4: "Common exception handler entry",
        0x000FDA: "Call error display routine",
        0x000FE0: "Halt (infinite loop)",
    }
    print_annotated_region(rom,
        "Region 1: Exception Handlers ($000F84-$000FE2)",
        0x000F84, 0x000FE2, r1_annot)

    # ═══════════════════════════════════════════════════════════════
    # Region 2: EXT INT Handler
    # ═══════════════════════════════════════════════════════════════
    r2_annot = {
        0x001480: "External interrupt -- unused, returns immediately",
    }
    print_annotated_region(rom,
        "Region 2: EXT INT Handler ($001480-$001484)",
        0x001480, 0x001484, r2_annot)

    # ═══════════════════════════════════════════════════════════════
    # Region 3: H-INT Handler
    # ═══════════════════════════════════════════════════════════════
    r3_annot = {
        0x001484: "H-INT entry: save SR",
        0x001486: "Disable interrupts during handler",
        0x00148A: "Save working registers",
        0x00148E: "A5 = work RAM base ($FFF010)",
        0x001494: "Read H-scroll line counter",
        0x001498: "Increment counter",
        0x00149A: "Store updated counter",
        0x00149E: "D1 = original counter (before double)",
        0x0014A0: "D0 = counter * 2 (word index into scroll tables)",
        0x0014A2: "Test scroll effect enable flag",
        0x0014A8: "Skip scroll update if disabled",
        0x0014AA: "A0 = scroll table B pointer",
        0x0014AE: "D2 = scroll B value at index",
        0x0014B2: "Subtract base scroll position",
        0x0014B4: "A0 = scroll table A pointer",
        0x0014B8: "D0 = scroll A value at index",
        0x0014BC: "Subtract base scroll position",
        0x0014BE: "VDP: set VSRAM write address 0",
        0x0014C8: "Write scroll B to VDP data port",
        0x0014CE: "VDP: set VSRAM write address 2",
        0x0014D8: "Write scroll A to VDP data port",
        0x0014DE: "Restore working registers",
        0x0014E2: "Restore SR",
        0x0014E4: "Return from interrupt",
    }
    print_annotated_region(rom,
        "Region 3: H-INT Handler ($001484-$0014E6)",
        0x001484, 0x0014E6, r3_annot)

    # ═══════════════════════════════════════════════════════════════
    # Region 4: V-INT Handler
    # ═══════════════════════════════════════════════════════════════
    r4_annot = {
        0x0014E6: "V-INT entry: save ALL registers",
        0x0014EA: "Stack overflow check: read SP",
        0x0014EC: "Compare against stack guard ($FFE000)",
        0x0014F2: "If SP < guard, jump to emergency handler",
        0x0014F6: "A5 = work RAM base ($FFF010)",
        0x0014FC: "A4 = VDP control port ($C00004)",
        0x001502: "Reset H-scroll counter to 0",
        0x001508: "Test DMA transfer flag",
        0x00150E: "Skip if not set",
        0x001510: "BSR to DMA transfer routine",
        0x001514: "Clear DMA flag after transfer",
        0x00151A: "Clear D0 for flag test",
        0x00151C: "Test display update flag",
        0x001520: "Skip if zero",
        0x001522: "BSR to display update",
        0x001526: "Clear D0",
        0x001528: "Test operation flag",
        0x00152C: "Skip if zero",
        0x00152E: "BSR to handler",
        0x001532: "Test word at $0BCE(A5)",
        0x001536: "Skip if zero",
        0x00153A: "BSR to handler",
        0x00153E: "Clear D0",
        0x001540: "Test controller enable flag",
        0x001544: "Skip if zero",
        0x001546: "BSR to controller read",
        0x00154A: "Clear D0",
        0x00154C: "Test multi-dispatch flags at $002B(A5)",
        0x001550: "Skip entire dispatch if zero",
        0x001554: "Test bit 0 (handler type 1)",
        0x00155A: "Skip if not set",
        0x00155C: "BSR handler type 1",
        0x001560: "Clear dispatch flags (one-shot)",
        0x001566: "Skip to end of dispatch",
        0x001568: "Test bit 1 (handler type 2)",
        0x00156E: "Skip if not set",
        0x001570: "BSR handler type 2",
        0x001574: "Skip to end of dispatch",
        0x001576: "Test bit 2 (handler type 3)",
        0x00157C: "Skip if not set",
        0x00157E: "BSR handler type 3",
        0x001582: "A1 = controller data area ($FFFBFC)",
        0x001588: "BSR to controller polling",
        0x00158C: "Subsystem update 1",
        0x001592: "Subsystem update 2",
        0x001598: "Subsystem update 3",
        0x00159E: "Subsystem update 4",
        0x0015A4: "Clear frame-done flag at $0036(A5)",
        0x0015AA: "Restore ALL registers",
        0x0015AE: "Return from interrupt",
    }
    print_annotated_region(rom,
        "Region 4: V-INT Handler ($0014E6-$0015B0)",
        0x0014E6, 0x0015B0, r4_annot)

    # ═══════════════════════════════════════════════════════════════
    # Region 5: Boot Code
    # ═══════════════════════════════════════════════════════════════
    r5_annot = {
        0x000200: "TMSS: test version register",
        0x000206: "Branch if not zero (version detected)",
        0x000208: "TMSS: test alternate register",
        0x00020E: "If nonzero, skip entire init (warm boot?)",
        0x000210: "A5 = pointer to inline data table",
        0x000214: "Load register pointers from table",
        0x000218: "Load address register pointers from table",
        0x00021C: "Read hardware version byte",
        0x000220: "Mask to low nibble",
        0x000224: "Skip SEGA write if version 0",
        0x000226: "Write 'SEGA' to TMSS register ($A14000)",
        0x00022E: "Read VDP control port (dummy read)",
        0x000230: "D0 = 0",
        0x000232: "A6 = 0 (clear frame pointer for USP)",
        0x000234: "Set user stack pointer = 0",
        0x000236: "Loop counter: 24 VDP registers (0-23)",
        0x000238: "VDP register init loop:",
        0x00023A: "Write register value to VDP control",
        0x00023C: "Add $8000 increment (next register)",
        0x00023E: "Loop until all 24 registers written",
        0x000242: "Load Z80 bus request address from table",
        0x000244: "Write 0 to Z80 bus request (request bus)",
        0x000246: "Write D7 to Z80 reset",
        0x000248: "Write D7 to Z80 bus release",
        0x00024A: "Wait for Z80 bus grant",
        0x00024C: "Loop until bus granted",
        0x00024E: "Loop counter: 38 bytes Z80 stub program",
        0x000250: "Copy Z80 stub from ROM to Z80 RAM",
        0x000252: "Loop until all bytes copied",
        0x000256: "Release Z80 bus",
        0x000258: "Clear Z80 reset",
        0x00025A: "Re-assert Z80 reset (starts Z80)",
        0x00025C: "Clear VRAM loop: write 0 longs",
        0x00025E: "Loop for all VRAM",
        0x000262: "Load CRAM write command from table",
        0x000264: "Load VSRAM write command from table",
        0x000266: "Loop counter: 32 longs = 128 bytes CRAM",
        0x000268: "Clear CRAM",
        0x00026A: "CRAM clear loop",
        0x00026E: "Load next hw address from table",
        0x000270: "Loop counter: 20 longs = 80 bytes VSRAM",
        0x000272: "Clear VSRAM",
        0x000274: "VSRAM clear loop",
        0x000278: "Loop counter: 4 I/O ports",
        0x00027A: "Initialize I/O data direction registers",
        0x00027E: "I/O init loop",
        0x000282: "Final write (clear something)",
        0x000284: "Restore registers from (A6) -- hw addr table",
        0x000288: "Disable all interrupts (supervisor, IPL=7)",
        0x00028C: "Skip over inline data table",
        0x0002FA: "Wait for V-Blank loop:",
        0x000300: "BSR to V-Blank wait subroutine",
        0x000304: "Check VDP status bit 2 (V-Blank)",
        0x000308: "Loop until V-Blank detected",
        0x00030A: "BSR to early init (RAM/VDP setup)",
        0x00030E: "D0 = 0 (for clearing work RAM vars)",
        0x000310: "A5 = $FFF010 (work RAM base pointer)",
        0x000316: "Clear controller enable flag",
        0x00031A: "Clear display update flag",
        0x00031E: "Clear flag $001C(A5)",
        0x000322: "Clear multi-dispatch flags",
        0x000326: "Clear DMA transfer flag",
        0x00032A: "Clear word at $0BCE(A5)",
        0x00032E: "Clear long at $0BD0(A5)",
        0x000332: "Clear byte at $0BD4(A5)",
        0x000336: "Clear word at $0C70(A5)",
        0x00033A: "JSR hardware init subroutine",
        0x000340: "Test expansion controller bit 6",
        0x000348: "Skip NOP if expansion present",
        0x00034C: "Placeholder NOP",
        0x00034E: "A0 = $FFF000 (work RAM dest for stub)",
        0x000354: "A1 = ROM $000362 (source: RAM subroutine)",
        0x00035A: "Copy 4 bytes (first long)",
        0x00035C: "Copy 4 more bytes (second long)",
        0x00035E: "Copy final word (10 bytes total)",
        0x000360: "Skip over inline RAM subroutine data",
        0x000362: "Inline data: RAM subroutine (VDP reg write + RTS)",
        0x00036C: "JSR VDP/display init",
        0x000372: "JSR init 2",
        0x000378: "JSR init 3",
        0x00037E: "JSR init 4",
        0x000384: "JSR Z80/Sound driver init (loads driver to Z80 RAM)",
        0x00038A: "JSR init 5",
        0x000390: "JSR init 6",
        0x000396: "Enable interrupts (supervisor, IPL=0)",
        0x00039A: "A0 = main game entry point ($D5B6)",
        0x0003A0: "Jump to main game -- BOOT COMPLETE",
    }
    r5_data = [
        (0x00028E, 0x0002FA, "Inline data table: VDP init, Z80 stub, hw addresses"),
        (0x000362, 0x00036C, "Inline RAM subroutine: move.w d16(a5),(a4) x2, rts"),
    ]
    print_annotated_region(rom,
        "Region 5: Boot Code ($000200-$0003A2)",
        0x000200, 0x0003A2, r5_annot, r5_data)


if __name__ == "__main__":
    main()
