import typing
from collections import namedtuple
import regex
from utils import *
import struct

match_dict = {
    "ORIG": r_whitespace + ".ORIG" + r_imm + r_comment,
    "LABEL_only": r_whitespace + r_raw_label + r_comment,
    "empty_line": r_whitespace + r_raw_comment,
    "ADD_1": r_head_label + "ADD" + r_reg + r_split + r_reg + r_split + r_reg + r_comment,
    "ADD_2": r_head_label + "ADD" + r_reg + r_split + r_reg + r_split + r_imm + r_comment,
    "AND_1": r_head_label + "AND" + r_reg + r_split + r_reg + r_split + r_reg + r_comment,
    "AND_2": r_head_label + "AND" + r_reg + r_split + r_reg + r_split + r_imm + r_comment,
    "BR": r_head_label + "BR" + "(n?z?p?)" + r_strong_whitespace + r_label + r_comment,
    "BR_1": r_head_label + "BR" + "(n?z?p?)" + r_strong_whitespace + r_imm + r_comment,
    "JMP": r_head_label + "JMP" + r_reg + r_comment,
    "RET": r_head_label + "RET" + r_comment,
    "JSR": r_head_label + "JSR" + r_label + r_comment,
    "JSR_1": r_head_label + "JSR" + r_imm + r_comment,
    "JSRR": r_head_label + "JSRR" + r_reg + r_comment,
    "LD": r_head_label + "LD" + r_reg + r_split + r_label + r_comment,
    "LD_1": r_head_label + "LD" + r_reg + r_split + r_imm + r_comment,
    "LDI": r_head_label + "LDI" + r_reg + r_split + r_label + r_comment,
    "LDI_1": r_head_label + "LDI" + r_reg + r_split + r_imm + r_comment,
    "LDR": r_head_label + "LDR" + r_reg + r_split + r_reg + r_split + r_imm + r_comment,
    "LEA": r_head_label + "LEA" + r_reg + r_split + r_label + r_comment,
    "LEA_1": r_head_label + "LEA" + r_reg + r_split + r_imm + r_comment,
    "NOT": r_head_label + "NOT" + r_reg + r_split + r_reg + r_comment,
    "RTI": r_head_label + "RTI" + r_comment,
    "ST": r_head_label + "ST" + r_reg + r_split + r_label + r_comment,
    "ST_1": r_head_label + "ST" + r_reg + r_split + r_imm + r_comment,
    "STI": r_head_label + "STI" + r_reg + r_split + r_label + r_comment,
    "STI_1": r_head_label + "STI" + r_reg + r_split + r_imm + r_comment,
    "STR": r_head_label + "STR" + r_reg + r_split + r_reg + r_split + r_imm + r_comment,
    "TRAP": r_head_label + "TRAP" + r_imm + r_comment,
    "GETC": r_head_label + "GETC" + r_comment,
    "OUT": r_head_label + "OUT" + r_comment,
    "PUTS": r_head_label + "PUTS" + r_comment,
    "IN": r_head_label + "IN" + r_comment,
    "PUTSP": r_head_label + "PUTSP" + r_comment,
    "HALT": r_head_label + "HALT" + r_comment,
    "FILL": r_head_label + ".FILL" + r_imm + r_comment,
    "FILL_1": r_head_label + ".FILL" + r_label + r_comment,
    "BLKW": r_head_label + ".BLKW" + r_imm + r_comment,
    "STRINGZ": r_head_label + ".STRINGZ" + r_str + r_comment,
    "END": r_whitespace + ".END" + r_comment,
}

# compiled_dict = {k: recom(v) for k, v in match_dict.items()}
compiled = namedtuple("CompiledCollection", list(match_dict))(
    **{key: recom(value) for key, value in match_dict.items()})  # this trick by fjw


def first_pass(fin: typing.TextIO) -> tuple:
    def add_label(m, start_addr):
        ret[m] = start_addr
        dprint("Get LABEL {}, set it as {}".format(m, hex(start_addr)))

    print("=== PASS 1 ===")
    ret = {}
    start_addr = addr = None
    for i in fin:
        if compiled.ORIG.match(i):
            m = compiled.ORIG.match(i).group(1)
            start_addr = addr = str_to_addr(m)
            dprint("Set starting address to {}".format(hex(addr)))
        elif addr:
            if compiled.empty_line.match(i):
                dprint("An empty line, do nothing.")
            elif compiled.LABEL_only.match(i):
                m = compiled.LABEL_only.match(i).group(1)
                if m.lower() in ["getc", "out", "puts", "in", "putsp", "halt", "ret", "rti"]:
                    dprint("Mismatched by LABEL_only, continue.")
                    addr += 1
                    continue
                add_label(m, addr)
            # elif regex.match()
            elif compiled.FILL.match(i):
                m = compiled.FILL.match(i).group(1)
                if m:
                    add_label(m, addr)
                else:
                    dprint("Get a FILL without LABEL.")
                addr += 1
            elif compiled.FILL_1.match(i):
                m = compiled.FILL_1.match(i).group(1)
                if m:
                    add_label(m, addr)
                else:
                    dprint("Get a FILL without LABEL.")
                addr += 1
            elif compiled.BLKW.match(i):
                mat = compiled.BLKW.match(i)
                m = mat.group(1)
                if m:
                    add_label(m, addr)
                else:
                    dprint("Get a BLKW without LABEL.")
                addr += int(str_to_addr(mat.group(2)))
            elif compiled.STRINGZ.match(i):
                mat = compiled.STRINGZ.match(i)
                m = mat.group(1)
                if m:
                    add_label(m, addr)
                else:
                    dprint("Get a STRINGZ without LABEL.")
                addr += len(str_decode(mat.group(2))) + 1  # length of string + '\0'
            elif compiled.END.match(i):
                break
            else:
                success = False
                for j in compiled:
                    if j != compiled.ORIG and j != compiled.empty_line and j != compiled.LABEL_only and j != compiled.FILL \
                            and j != compiled.FILL_1 and j != compiled.BLKW and j != compiled.STRINGZ and j != compiled.END:
                        if j.match(i):
                            m = j.match(i).group(1)
                            if m:
                                add_label(m, addr)
                            else:
                                dprint("Line {} has no LABEL".format(i.strip()))
                            addr += 1
                            success = True
                if not success:
                    raise ValueError("Unrecognized line {}".format(i.strip()))

    if addr is None:
        raise ValueError("Not found .ORIG")

    dprint("The end of addr is {}".format(hex(addr)))
    dprint("Symbol Table: {}".format({k: hex(v) for k, v in ret.items()}))

    fin.seek(0)

    return ret, start_addr


def second_pass(fin: typing.TextIO, fout: typing.BinaryIO, sym_table: dict, start_addr: int):
    def dprint_op(opcode: str, operand1: str = None, operand2: str = None, operand3: str = None):
        dprint("Opcode {} with {}, {} and {}".format(opcode, operand1, operand2, operand3))

    def dprint_bincode(bincode: int):
        if bincode is None:
            return
        dprint(bin(bincode)[2:].rjust(16, "0"))

    def is_validreg(op: int):
        if not 0 <= op <= 7:
            raise ValueError("Invalid Register {}".format(op))

    def is_validimm(op: int, width: int = 5, signed: bool = True):
        if (signed and not -2 ** (width - 1) <= op <= 2 ** (width - 1) - 1) \
                or (not signed and not 0 <= op <= 2 ** width - 1):
            raise ValueError("Invalid Immediate Number {}".format(op))

    def is_validlabel(op: str):
        if not op in sym_table:
            raise ValueError("Invalid Label {}".format(op))

    def label_offset(label: str, pc: int, width: int = 9):
        ret = sym_table[label] - pc - 1
        is_validimm(ret, width)
        return ret & (2 ** width - 1)

    def signed_conv(op: int, width: int = 5):
        return op & (2 ** width - 1)

    def imm_handle(op: str, width: int):
        op = op.lower()
        signed = False if op[0] == 'x' else True
        op = str_to_addr(op)
        is_validimm(op, width, signed)
        if signed:
            op = signed_conv(op, width)
        return op

    def write_bincode(bincode: int):
        if bincode is not None:
            dprint_bincode(bincode)
            fout.write(struct.pack(">H", bincode))
        else:
            assert 0

    print("=== PASS 2 ===")
    write_bincode(start_addr)  # start address for lc3sim

    for i in fin:
        bin_code = None
        if compiled.ADD_1.match(i):
            mat = compiled.ADD_1.match(i)
            op1 = mat.group(2); op2 = mat.group(3); op3 = mat.group(4)
            dprint_op("ADD", "R" + op1, "R" + op2, "R" + op3)
            op1 = int(op1); op2 = int(op2); op3 = int(op3)
            is_validreg(op1); is_validreg(op2); is_validreg(op3)
            bin_code = 0x1000 | (op1 << 9) | (op2 << 6) | (op3)
        elif compiled.ADD_2.match(i):
            mat = compiled.ADD_2.match(i)
            op1 = mat.group(2); op2 = mat.group(3); op3 = mat.group(4)
            dprint_op("ADD", "R" + op1, "R" + op2, op3)
            op1 = int(op1); op2 = int(op2); op3 = imm_handle(op3, 5)
            is_validreg(op1); is_validreg(op2)
            op3 = signed_conv(op3)
            bin_code = 0x1020 | (op1 << 9) | (op2 << 6) | (op3)
        elif compiled.AND_1.match(i):
            mat = compiled.AND_1.match(i)
            op1 = mat.group(2); op2 = mat.group(3); op3 = mat.group(4)
            dprint_op("AND", "R" + op1, "R" + op2, "R" + op3)
            op1 = int(op1); op2 = int(op2); op3 = int(op3)
            is_validreg(op1); is_validreg(op2); is_validreg(op3)
            bin_code = 0x5000 | (op1 << 9) | (op2 << 6) | (op3)
        elif compiled.AND_2.match(i):
            mat = compiled.AND_2.match(i)
            op1 = mat.group(2); op2 = mat.group(3); op3 = mat.group(4)
            dprint_op("AND", "R" + op1, "R" + op2, op3)
            op1 = int(op1); op2 = int(op2); op3 = imm_handle(op3, 5)
            is_validreg(op1); is_validreg(op2)
            bin_code = 0x5020 | (op1 << 9) | (op2 << 6) | (op3)
        elif compiled.BR.match(i):
            mat = compiled.BR.match(i)
            op1 = mat.group(2); op2 = mat.group(3)
            dprint_op("BR", op1, op2)
            is_validlabel(op2)
            pc_offset = label_offset(op2, start_addr)
            bin_code = 0x0000 | (0x0800 if "n" in op1 else 0) | (0x0400 if "z" in op1 else 0) | (0x0200 if "p" in op1 else 0) | pc_offset
        elif compiled.BR_1.match(i):
            mat = compiled.BR_1.match(i)
            op1 = mat.group(2); op2 = mat.group(3)
            dprint_op("BR", op1, op2)
            op2 = imm_handle(op2, 9)
            bin_code = 0x0000 | (0x0800 if "n" in op1 else 0) | (0x0400 if "z" in op1 else 0) | (0x0200 if "p" in op1 else 0) | op2
        elif compiled.JMP.match(i):
            mat = compiled.JMP.match(i)
            op1 = mat.group(2)
            dprint_op("JMP", "R" + op1)
            op1 = int(op1); is_validreg(op1)
            bin_code = 0xc000 | (op1 << 6)
        elif compiled.JSR.match(i):
            mat = compiled.JSR.match(i)
            op1 = mat.group(2)
            dprint_op("JSR", op1)
            is_validlabel(op1)
            pc_offset = label_offset(op1, start_addr, 11)
            bin_code = 0x4800 | pc_offset
        elif compiled.JSR_1.match(i):
            mat = compiled.JSR_1.match(i)
            op1 = mat.group(2)
            dprint_op("JSR", op1)
            op1 = imm_handle(op1, 11)
            bin_code = 0x4800 | op1
        elif compiled.JSRR.match(i):
            mat = compiled.JSRR.match(i)
            op1 = mat.group(2)
            dprint_op("JSRR", "R" + op1)
            op1 = int(op1); is_validreg(op1)
            bin_code = 0x4000 | (op1 << 6)
        elif compiled.LD.match(i):
            mat = compiled.LD.match(i)
            op1 = mat.group(2); op2 = mat.group(3)
            dprint_op("LD", "R" + op1, op2)
            op1 = int(op1); is_validreg(op1)
            is_validlabel(op2); pc_offset = label_offset(op2, start_addr)
            bin_code = 0x2000 | (op1 << 9) | pc_offset
        elif compiled.LD_1.match(i):
            mat = compiled.LD_1.match(i)
            op1 = mat.group(2); op2 = mat.group(3)
            dprint_op("LD", "R" + op1, op2)
            op1 = int(op1); is_validreg(op1)
            op2 = imm_handle(op2, 9)
            bin_code = 0x2000 | (op1 << 9) | op2
        elif compiled.LDI.match(i):
            mat = compiled.LDI.match(i)
            op1 = mat.group(2); op2 = mat.group(3)
            dprint_op("LDI", "R" + op1, op2)
            op1 = int(op1); is_validreg(op1)
            is_validlabel(op2); pc_offset = label_offset(op2, start_addr)
            bin_code = 0xa000 | (op1 << 9) | pc_offset
        elif compiled.LDI_1.match(i):
            mat = compiled.LDI_1.match(i)
            op1 = mat.group(2); op2 = mat.group(3)
            dprint_op("LDI", "R" + op1, op2)
            op1 = int(op1); is_validreg(op1)
            op2 = imm_handle(op2, 9)
            bin_code = 0xa000 | (op1 << 9) | op2
        elif compiled.LDR.match(i):
            mat = compiled.LDR.match(i)
            op1 = mat.group(2); op2 = mat.group(3); op3 = mat.group(4)
            dprint_op("LDR", "R" + op1, "R" + op2, op3)
            op1 = int(op1); is_validreg(op1); op2 = int(op2); is_validreg(op2)
            op3 = imm_handle(op3, 6)
            bin_code = 0x6000 | (op1 << 9) | (op2 << 6) | op3
        elif compiled.LEA.match(i):
            mat = compiled.LEA.match(i)
            op1 = mat.group(2); op2 = mat.group(3)
            dprint_op("LEA", "R" + op1, op2)
            op1 = int(op1); is_validreg(op1)
            is_validlabel(op2);  pc_offset = label_offset(op2, start_addr)
            bin_code = 0xe000 | (op1 << 9) | pc_offset
        elif compiled.LEA_1.match(i):
            mat = compiled.LEA_1.match(i)
            op1 = mat.group(2); op2 = mat.group(3)
            dprint_op("LEA", "R" + op1, op2)
            op1 = int(op1); is_validreg(op1)
            op2 = imm_handle(op2, 9)
            bin_code = 0xe000 | (op1 << 9) | op2
        elif compiled.NOT.match(i):
            mat = compiled.NOT.match(i)
            op1 = mat.group(2); op2 = mat.group(3)
            dprint_op("NOT", "R" + op1, "R" + op2)
            op1 = int(op1); is_validreg(op1); op2 = int(op2); is_validreg(op2)
            bin_code = 0x903f | (op1 << 9) | (op2 << 6)
        elif compiled.RET.match(i):
            dprint_op("RET")
            bin_code = 0xc1c0
        elif compiled.RTI.match(i):
            dprint_op("RTI")
            bin_code = 0x8000
        elif compiled.ST.match(i):
            mat = compiled.ST.match(i)
            op1 = mat.group(2); op2 = mat.group(3)
            dprint_op("ST", "R" + op1, op2)
            op1 = int(op1); is_validreg(op1)
            is_validlabel(op2); pc_offset = label_offset(op2, start_addr)
            bin_code = 0x3000 | (op1 << 9) | pc_offset
        elif compiled.ST_1.match(i):
            mat = compiled.ST_1.match(i)
            op1 = mat.group(2); op2 = mat.group(3)
            dprint_op("ST", "R" + op1, op2)
            op1 = int(op1); is_validreg(op1)
            op2 = imm_handle(op2, 9)
            bin_code = 0x3000 | (op1 << 9) | op2
        elif compiled.STI.match(i):
            mat = compiled.STI.match(i)
            op1 = mat.group(2); op2 = mat.group(3)
            dprint_op("STI", "R" + op1, op2)
            op1 = int(op1); is_validreg(op1)
            is_validlabel(op2); pc_offset = label_offset(op2, start_addr)
            bin_code = 0xb000 | (op1 << 9) | pc_offset
        elif compiled.STI_1.match(i):
            mat = compiled.STI_1.match(i)
            op1 = mat.group(2); op2 = mat.group(3)
            dprint_op("STI", "R" + op1, op2)
            op1 = int(op1); is_validreg(op1)
            op2 = imm_handle(op2, 9)
            bin_code = 0xb000 | (op1 << 9) | op2
        elif compiled.STR.match(i):
            mat = compiled.STR.match(i)
            op1 = mat.group(2); op2 = mat.group(3); op3 = mat.group(4)
            dprint_op("STR", "R" + op1, "R" + op2, op3)
            op1 = int(op1); is_validreg(op1); op2 = int(op2); is_validreg(op2)
            op3 = imm_handle(op3, 6)
            bin_code = 0x7000 | (op1 << 9) | (op2 << 6) | op3
        elif compiled.TRAP.match(i):
            mat = compiled.TRAP.match(i)
            op1 = mat.group(2)
            dprint_op("TRAP", op1)
            op1 = imm_handle(op1, 8)
            if op1 < 0: raise ValueError("TRAP vector should be >= 0")
            bin_code = 0xf000 | op1
        elif compiled.GETC.match(i):
            dprint_op("GETC")
            bin_code = 0xf020
        elif compiled.OUT.match(i):
            dprint_op("OUT")
            bin_code = 0xf021
        elif compiled.PUTS.match(i):
            dprint_op("PUTS")
            bin_code = 0xf022
        elif compiled.IN.match(i):
            dprint_op("IN")
            bin_code = 0xf023
        elif compiled.PUTSP.match(i):
            dprint_op("PUTSP")
            bin_code = 0xf024
        elif compiled.HALT.match(i):
            dprint_op("HALT")
            bin_code = 0xf025
        elif compiled.FILL.match(i):
            mat = compiled.FILL.match(i)
            op1 = mat.group(2)
            dprint_op(".FILL", op1)
            op1 = imm_handle(op1, 16)
            bin_code = op1
        elif compiled.FILL_1.match(i):
            mat = compiled.FILL_1.match(i)
            op1 = mat.group(2)
            dprint_op(".FILL", op1)
            is_validlabel(op1)
            bin_code = sym_table[op1]
        elif compiled.END.match(i):
            break
        else:
            # handle BLKW and STRINGZ
            if compiled.BLKW.match(i):
                mat = compiled.BLKW.match(i)
                op1 = mat.group(2)
                dprint_op(".BLKW", op1)
                op1 = str_to_addr(op1)
                if op1 <= 0: raise ValueError(".BLKW should fill in > 0 elements!")
                for j in range(op1):
                    write_bincode(0)
                start_addr += op1
            elif compiled.STRINGZ.match(i):
                mat = compiled.STRINGZ.match(i)
                op1 = mat.group(2) # the string
                dprint_op(".STRINGZ", op1)
                op1 = str_decode(op1)
                for j in op1:
                    write_bincode(ord(j))
                write_bincode(0)
                start_addr += len(op1) + 1
            continue

        start_addr += 1
        write_bincode(bin_code)
