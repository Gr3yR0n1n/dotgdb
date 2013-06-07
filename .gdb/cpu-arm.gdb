# Initialize these variables else comparisons will fail for colouring
set $oldr0  = 0
set $oldr1  = 0
set $oldr2  = 0
set $oldr3  = 0
set $oldr4  = 0
set $oldr5  = 0
set $oldr6  = 0
set $oldr7  = 0
set $oldr8  = 0
set $oldr9  = 0
set $oldr10 = 0
set $oldr11 = 0
set $oldr12 = 0
set $oldr13 = 0
set $oldr14 = 0
set $oldr15 = 0
set $oldsp  = 0
set $oldlr  = 0


define _setflagsarm
  if $_APPLE
    set $_n_flag = $cspr->n & 1

    # zero (Z), bit 30
    set $_z_flag = $cspr->z & 1

    # Carry/Borrow/Extend (C), bit 29
    set $_c_flag = $cspr->c & 1

    # Overflow (V), bit 28
    set $_v_flag = $cspr->v & 1

    # Sticky overflow (Q), bit 27
    set $_q_flag = $cspr->q & 1

    # Java state bit (J), bit 24
    # When T=1:
    # J = 0 The processor is in Thumb state.
    # J = 1 The processor is in ThumbEE state.
    set $_j_flag = $cspr->j & 1

    # Data endianness bit (E), bit 9
    set $_e_flag = $cspr->e & 1

    # Imprecise abort disable bit (A), bit 8
    # The A bit is set to 1 automatically. It is used to disable imprecise data aborts.
    # It might not be writable in the Nonsecure state if the AW bit in the SCR register is reset.
    set $_a_flag = $cspr->a & 1

    # IRQ disable bit (I), bit 7
    # When the I bit is set to 1, IRQ interrupts are disabled.
    set $_i_flag = $cspr->i & 1

    # FIQ disable bit (F), bit 6
    # When the F bit is set to 1, FIQ interrupts are disabled.
    # FIQ can be nonmaskable in the Nonsecure state if the FW bit in SCR register is reset.
    set $_f_flag = $cspr->f & 1

    # Thumb state bit (F), bit 5
    # if 1 then the processor is executing in Thumb state or ThumbEE state depending on the J bit
    set $_t_flag = $cspr->t & 1

    # TODO: GE bit ?
  else
    set $_n_flag = ($cpsr >> 0x1F) & 1
    set $_z_flag = ($cpsr >> 0x1E) & 1
    set $_c_flag = ($cpsr >> 0x1D) & 1
    set $_v_flag = ($cpsr >> 0x1C) & 1
    set $_q_flag = ($cpsr >> 0x1B) & 1
    set $_j_flag = ($cpsr >> 0x18) & 1
    set $_e_flag = ($cpsr >> 0x9) & 1
    set $_a_flag = ($cpsr >> 0x8) & 1
    set $_i_flag = ($cpsr >> 0x7) & 1
    set $_f_flag = ($cpsr >> 0x6) & 1
    set $_t_flag = ($cpsr >> 0x5) & 1

    # TODO: GE bit ?
  end
end


define flagsarm
  _setflagsarm

  # conditional flags are
  # negative/less than (N), bit 31 of CPSR
  # zero (Z), bit 30
  # Carry/Borrow/Extend (C), bit 29
  # Overflow (V), bit 28
  # negative/less than (N), bit 31 of CPSR
  if $_n_flag
      printf "N "
  else
      printf "n "
  end
  # zero (Z), bit 30
  if $_z_flag
    printf "Z "
  else
    printf "z "
  end
  # Carry/Borrow/Extend (C), bit 29
  if $_c_flag
    printf "C "
  else
    printf "c "
  end
  # Overflow (V), bit 28
  if $_v_flag
    printf "V "
  else
    printf "v "
  end
  # Sticky overflow (Q), bit 27
  if $_q_flag
    printf "Q "
  else
    printf "q "
  end
  # Java state bit (J), bit 24
  # When T=1:
  # J = 0 The processor is in Thumb state.
  # J = 1 The processor is in ThumbEE state.
  if $_j_flag
    printf "J "
  else
    printf "j "
  end
  # Data endianness bit (E), bit 9
  if $_e_flag
    printf "E "
  else
    printf "e "
  end
  # Imprecise abort disable bit (A), bit 8
  # The A bit is set to 1 automatically. It is used to disable imprecise data aborts.
  # It might not be writable in the Nonsecure state if the AW bit in the SCR register is reset.
  if $_a_flag
    printf "A "
  else
    printf "a "
  end
  # IRQ disable bit (I), bit 7
  # When the I bit is set to 1, IRQ interrupts are disabled.
  if $_i_flag
    printf "I "
  else
    printf "i "
  end
  # FIQ disable bit (F), bit 6
  # When the F bit is set to 1, FIQ interrupts are disabled.
  # FIQ can be nonmaskable in the Nonsecure state if the FW bit in SCR register is reset.
  if $_f_flag
    printf "F "
  else
    printf "f "
  end
  # Thumb state bit (F), bit 5
  # if 1 then the processor is executing in Thumb state or ThumbEE state depending on the J bit
  if $_t_flag
    printf "T "
  else
    printf "t "
  end
end
document flagsarm
Auxiliary function to set ARM cpu flags.
end


define eflagsarm
  if $_APPLE
    printf "     N <%d>  Z <%d>  C <%d>  V <%d>", \
           ($cpsr->n & 1), ($cpsr->z & 1), \
           ($cpsr->c & 1), ($cpsr->v & 1)
    printf "  Q <%d>  J <%d>  GE <%d>  E <%d>  A <%d>", \
           ($cpsr->q & 1), ($cpsr->j & 1), \
           ($cpsr->ge), ($cpsr->e & 1), ($cpsr->a & 1)
    printf "  I <%d>  F <%d>  T <%d> \n", \
           ($cpsr->i & 1), ($cpsr->f & 1), \
           ($cpsr->t & 1)
  else
    printf "     N <%d>  Z <%d>  C <%d>  V <%d>", \
           (($cpsr >> 0x1F) & 1), (($cpsr >> 0x1E) & 1), \
           (($cpsr >> 0x1D) & 1), (($cpsr >> 0x1C) & 1)
    printf "  Q <%d>  J <%d>  GE <%d>  E <%d>  A <%d>", \
           (($cpsr >> 0x1B) & 1), (($cpsr >> 0x18) & 1), \
           (($cpsr >> 0x10) & 0xF), (($cpsr >> 9) & 1), (($cpsr >> 8) & 1)
    printf "  I <%d>  F <%d>  T <%d> \n", \
           (($cpsr >> 7) & 1), (($cpsr >> 6) & 1), \
           (($cpsr >> 5) & 1)
  end
end
document eflagsarm
Auxillary function to print ARM eflags register.
end

define cpsr
  eflagsarm
end
document cpsr
Print cpsr register.
end


define regarm
  _setflagsarm

  printf "  "
  echo \033[32m
  printf " R0:"
  if $r0
    if ($r0 != $oldr0 && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X  ", $r0
  else
    printf " 0x%08X  ", 0
  end

  echo \033[32m
  printf " R1:"
  if $r1
    if ($r1 != $oldr1 && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X  ", $r1
  else
    printf " 0x%08X  ", 0
  end

  echo \033[32m
  printf " R2:"
  if $r2
    if ($r2 != $oldr2 && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X  ", $r2
  else
    printf " 0x%08X  ", 0
  end

  echo \033[32m
  printf " R3:"
  if $r3
    if ($r3 != $oldr3 && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X", $r3
  else
    printf " 0x%08X", 0
  end


  # Newline
  printf "\n  "

  echo \033[32m
  printf " R4:"
  if $r4
    if ($r4 != $oldr4 && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X  ", $r4
  else
    printf " 0x%08X  ", 0
  end

  echo \033[32m
  printf " R5:"
  if $r5
    if ($r5 != $oldr5 && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X  ", $r5
  else
    printf " 0x%08X  ", 0
  end

  echo \033[32m
  printf " R6:"
  if $r6
    if ($r6 != $oldr6 && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X  ", $r6
  else
    printf " 0x%08X  ", 0
  end

  echo \033[32m
  printf " R7:"
  if $r7
    if ($r7 != $oldr7 && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X  ", $r7
  else
    printf " 0x%08X  ", 0
  end


  # Newline
  printf "\n  "

  echo \033[32m
  printf " R8:"
  if $r8
    if ($r8 != $oldr8 && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X  ", $r8
  else
    printf " 0x%08X  ", 0
  end

  echo \033[32m
  printf " R9:"
  if $r9
    if ($r9 != $oldr9 && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X  ", $r9
  else
    printf " 0x%08X  ", 0
  end

  echo \033[32m
  printf "R10:"
  if $r10
    if ($r10 != $oldr10 && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X  ", $r10
  else
    printf " 0x%08X  ", 0
  end

  echo \033[32m
  printf "R11:"
  if $r11
    if ($r11 != $oldr11 && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X ", $r11
  else
    printf " 0x%08X ", 0
  end

  dumpjump
  printf "\n  "

  echo \033[32m
  printf "R12:"
  if $r12
    if ($r12 != $oldr12 && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X  ", $r12
  else
    printf " 0x%08X  ", 0
  end

  echo \033[32m
  printf " SP:"
  if $sp
    if ($sp != $oldsp && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X  ", $sp
  else
    printf " 0x%08X  ", 0
  end

  echo \033[32m
  printf " LR:"
  if $lr
    if ($lr != $oldlr && $SHOWREGCHANGES == 1)
      echo \033[31m
    end
    printf " 0x%08X  ", $lr
  else
    printf " 0x%08X  ", 0
  end

  echo \033[32m
  printf " PC:"
  echo \033[0m
  if $pc
    printf "  0x%08X  ", $pc
  else
    printf "  0x%08X  ", 0
  end

  echo \033[1m\033[4m\033[31m
  flags
  echo \033[0m
  printf "\n"

  if ($SHOWREGCHANGES == 1)
    if $r0
      set $oldr0  = $r0
    end
    if $r1
      set $oldr1  = $r1
    end
    if $r2
      set $oldr2  = $r2
    end
    if $r3
      set $oldr3  = $r3
    end
    if $r4
      set $oldr4  = $r4
    end
    if $r5
      set $oldr5  = $r5
    end
    if $r6
      set $oldr6  = $r6
    end
    if $r7
      set $oldr7  = $r7
    end
    if $r8
      set $oldr8  = $r8
    end
    if $r9
      set $oldr9  = $r9
    end
    if $r10
      set $oldr10 = $r10
    end
    if $r11
      set $oldr11 = $r11
    end
    if $r12
      set $oldr12 = $r12
    end
    if $sp
      set $oldsp  = $sp
    end
    if $lr
      set $oldlr  = $lr
    end
  end
end
document regarm
Auxiliary function to display ARM registers.
end


define stepoframeworkarm
  # bl and bx opcodes
  # bx Rn  => ARM bits 27-20: 0 0 0 1 0 0 1 0 , bits 7-4: 0 0 0 1 ; Thumb bits: 15-7: 0 1 0 0 0 1 1 1 0
  # blx Rn => ARM bits 27-20: 0 0 0 1 0 0 1 0 , bits 7-4: 0 0 1 1 ; Thumb bits: 15-7: 0 1 0 0 0 1 1 1 1
  # bl # => ARM bits 27-24: 1 0 1 1 ; Thumb bits: 15-11: 1 1 1 1 0
  # blx # => ARM bits 31-25: 1 1 1 1 1 0 1 ; Thumb bits: 15-11: 1 1 1 1 0
  set $_nextaddress = 0

  # ARM Mode
  if ($_t_flag == 0)
    set $_branchesint = *(unsigned int*) $pc
    set $_bit31 = ($_branchesint >> 0x1F) & 1
    set $_bit30 = ($_branchesint >> 0x1E) & 1
    set $_bit29 = ($_branchesint >> 0x1D) & 1
    set $_bit28 = ($_branchesint >> 0x1C) & 1
    set $_bit27 = ($_branchesint >> 0x1B) & 1
    set $_bit26 = ($_branchesint >> 0x1A) & 1
    set $_bit25 = ($_branchesint >> 0x19) & 1
    set $_bit24 = ($_branchesint >> 0x18) & 1
    set $_bit23 = ($_branchesint >> 0x17) & 1
    set $_bit22 = ($_branchesint >> 0x16) & 1
    set $_bit21 = ($_branchesint >> 0x15) & 1
    set $_bit20 = ($_branchesint >> 0x14) & 1
    set $_bit7 = ($_branchesint >> 0x7) & 1
    set $_bit6 = ($_branchesint >> 0x6) & 1
    set $_bit5 = ($_branchesint >> 0x5) & 1
    set $_bit4 = ($_branchesint >> 0x4) & 1

    #	set $_lastbyte = *(unsigned char *)($pc+3)
    #	set $_bits2724 = $_lastbyte & 0x1
    #	set $_bits3128 = $_lastbyte >> 4
    #	if ($_bits3128 == 0xF)
    #		set $_bits2724 = $_lastbyte & 0xA
    #		set $_bits2724 = $_bits2724 >> 1
    #	end
    #	set $_previousbyte = *(unsigned char *)($pc+2)
    #	set $_bits2320 = $_previousbyte >> 4
    #	printf "bits2724: %x bits2320: %x\n", $_bits2724, $_bits2320

    if ($_bit27 == 0 && $_bit26 == 0 && $_bit25 == 0 && $_bit24 == 1 && $_bit23 == 0 && $_bit22 == 0 && $_bit21 == 1 && $_bit20 == 0 && $_bit7 == 0 && $_bit6 == 0 && $_bit5 == 0 && $_bit4 == 1)
      printf "Found a bx Rn\n"
      set $_nextaddress = $pc + 0x4
    end
    if ($_bit27 == 0 && $_bit26 == 0 && $_bit25 == 0 && $_bit24 == 1 && $_bit23 == 0 && $_bit22 == 0 && $_bit21 == 1 && $_bit20 == 0 && $_bit7 == 0 && $_bit6 == 0 && $_bit5 == 1 && $_bit4 == 1)
      printf "Found a blx Rn\n"
      set $_nextaddress = $pc + 0x4
    end
    if ($_bit27 == 1 && $_bit26 == 0 && $_bit25 == 1 && $_bit24 == 1)
      printf "Found a bl #\n"
      set $_nextaddress = $pc + 0x4
    end
    if ($_bit31 == 1 && $_bit30 == 1 && $_bit29 == 1 && $_bit28 == 1 && $_bit27 == 1 && $_bit26 == 0 && $_bit25 == 1)
      printf "Found a blx #\n"
      set $_nextaddress = $pc + 0x4
    end
    # Thumb Mode
  else
    # 32 bits instructions in Thumb are divided into two half words
    set $_hw1 = *(unsigned short*) ($pc)
    set $_hw2 = *(unsigned short*) ($pc + 2)

    # bl/blx (immediate)
    # hw1: bits 15-11: 1 1 1 1 0
    # hw2: bits 15-14: 1 1 ; BL bit 12: 1 ; BLX bit 12: 0
    if (($_hw1 >> 0xC) == 0xF && (($_hw1 >> 0xB) & 1) == 0)
      if (((($_hw2 >> 0xF) & 1) == 1) && ((($_hw2 >> 0xE) & 1) == 1))
        set $_nextaddress = $pc + 0x4
      end
    end
  end
  # if we have found a call to bypass we set a temporary breakpoint on next instruction and continue
  if ($_nextaddress != 0)
    tbreak *$_nextaddress
    continue
    printf "[StepO] Next address will be %x\n", $_nextaddress
    # else we just single step
  else
    nexti
  end
end
document stepoframeworkarm
Auxiliary function to stepo command.
end


define cfnarm
  if $_APPLE
    set $tempflag = $cpsr->n
    if ($tempflag & 1)
      set $cpsr->n = $tempflag & ~0x1
    else
      set $cpsr->n = $tempflag | 0x1
    end
  else
    set $cpsr = $cpsr ^ (1 << 31)
  end
end
document cfnarm
Auxiliary function to change ARM Negative/Less Than Flag.
end


define cfcarm
  # Carry/Borrow/Extend (C), bit 29
  if $_APPLE
    set $tempflag = $cpsr->c
    if ($tempflag & 1)
      set $cpsr->c = $tempflag & ~0x1
    else
      set $cpsr->c = $tempflag | 0x1
    end
  else
    set $cpsr = $cpsr ^ (1 << 29)
  end
end
document cfcarm
Auxiliary function to change ARM Carry Flag.
end


define cfzarm
  # zero (Z), bit 30
  if $_APPLE
    set $tempflag = $cpsr->z
    if ($tempflag & 1)
      set $cpsr->z = $tempflag & ~0x1
    else
      set $cpsr->z = $tempflag | 0x1
    end
  else
    set $cpsr = $cpsr ^ (1 << 30)
  end
end
document cfzarm
Auxiliary function to change ARM Zero Flag.
end


# Overflow (V), bit 28
define cfvarm
  if $_APPLE
    set $tempflag = $cpsr->v
    if ($tempflag & 1)
      set $cpsr->v = $tempflag & ~0x1
    else
      set $cpsr->v = $tempflag | 0x1
    end
  else
    set $cpsr = $cpsr ^ (1 << 28)
  end
end
document cfvarm
Auxiliary function to change ARM Overflow Flag.
end


define hookstoparm
  # Display instructions formats
  if $ARMOPCODES == 1
    set arm show-opcode-bytes 1
  else
    set arm show-opcode-bytes 1
  end
end
document hookstoparm
!!! FOR INTERNAL USE ONLY - DO NOT CALL !!!
end
