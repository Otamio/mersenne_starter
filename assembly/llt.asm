# llt.asm
# int LLT(int p) {
# 	Bigint zero = digit_to_big(0);
# 	Bigint one  = digit_to_big(1);
# 	Bigint two  = digit_to_big(2);
#
# 	Bigint Mp = pow_big(two, p);
# 	Mp =  sub_big(Mp, one);
#
# 	Bigint s = digit_to_big(4);
#
# 	for (int i = 0; i < p - 2; ++i) {
# 		s = mult_big(s, s);
# 		s = sub_big(s, two);
# 		s = mod_big(s, Mp);
# 	}
#
# 	if (compare_big(s, zero) == 0)
# 		return 1;
# 	else
# 		return 0;
# }
  .data
test_k:   .asciiz "LLT Tests"
newline:  .asciiz "\n"
.align 2
bigint1:  .space  1404
.align 2
bigint2:  .space  1404
.align 2
bigint3:  .space  1404
.align 2
bigint8:  .space  1404
.align 2
bigint9:  .space  1404
# stores 0
.align 2
bigint11:  .space  1404
# stores 1
.align 2
bigint12:  .space  1404
# stores 2
.align 2
bigint13:  .space  1404
# stores Mp
.align 2
bigint14:  .space 1404
# stores s
.align 2
bigint15: .space  1404
# stores tmp in LLT
.align 2
bigint19:  .space 1404

  .text
LLT:
# save state
  addi $sp, $sp, -36          # 8 elements are pushed onto the stack
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

########################################
### ------------------------------------
### p := $s0
########################################

# read parameters
  move $s0, $a0               # $s0 is p

########################################
### Bigint zero = digit_to_big(0);
### ------------------------------------
### zero := $s7
########################################

# load address
  la $s7, bigint11            # $s7 stores the starting address of bigint10

# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# initialize memory
  move $a0, $s7               # initialize $s7
  jal init_bigint

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# fill value
  li $t0, 1
  lw $t0, 0($s7)              # size of "0" is 1
  li $t0, 0
  lw $t0, 4($s7)              # the digit of "0" is 0

########################################
### Bigint one  = digit_to_big(1);
### ------------------------------------
### one := $s6
########################################

# load address
  la $s6, bigint12            # $s6 stores the starting address of bigint11

# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# initialize memory
  move $a0, $s6               # initialize $s6
  jal init_bigint

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# fill value
  li $t0, 1
  lw $t0, 0($s6)              # size of "1" is 1
  li $t0, 1
  lw $t0, 4($s6)              # the digit of "1" is 1

########################################
### Bigint two  = digit_to_big(2);
### ------------------------------------
### two := $s5
########################################

# load address
  la $s5, bigint13            # $s6 stores the starting address of bigint11

# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# initialize memory
  move $a0, $s5               # initialize $s5
  jal init_bigint

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# fill value
  li $t0, 1
  lw $t0, 0($s5)              # size of "2" is 1
  li $t0, 2
  lw $t0, 4($s5)              # the digit of "2" is 2

########################################
### Bigint Mp = pow_big(two, p);
### ------------------------------------
### Mp := $s1
########################################

### Initialize Memory ##################

# load address
  la $s1, bigint14            # $s1 stores the starting address of Mp

# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# initialize memory
  move $a0, $s1               # initialize $s1
  jal init_bigint

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

### Call pow_big ##################

# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call pow_big
  move $a0, $s5               # arg1: 2
  move $a1, $s0               # arg2: p
  move $a2, $s1               # arg3: Mp
  jal pow_big

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# get return value
  move $s1, $v0               # $s1 is Mp

########################################
### Mp = sub_big(Mp, one);
### ------------------------------------
### Mp := $s1
########################################

# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call sub_big
  move $a0, $s1               # arg1: Mp
  move $a1, $s6               # arg2: 1
  la $a2, bigint19            # arg3: tmp

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# get return value and copy to Mp
# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call copy_bigint
  move $a0, $v0
  move $a1, $s1
  jal copy_bigint

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

########################################
### Bigint s = digit_to_big(4);
### ------------------------------------
### s := $s2
########################################

# Initialize s
  la $s2, bigint15

# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call init_bigint
  move $a0, $s2               # initialize $s4 (bigint13)
  jal init_bigint

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# fill value
  li $t0, 1
  lw $t0, 0($s2)              # size of "4" is 1
  li $t0, 4
  lw $t0, 4($s2)              # the digit of "4" is 4

########################################
### for (int i = 0; i < p - 2; ++i) {}
### ------------------------------------
### i := $s3
### p-2 := $t9
########################################

# loop initialization
  li $s2, 0                   # $s2 is i (0)
  addi $t9, $s0, -2           # $t9 = p-2

LLT_loop:
  bge $s2, $t9, LLT_loop_exit # branch if i >= p-2

########################################
### s = mult_big(s, s);
### ------------------------------------
### s := $s2
########################################

### call multiplication ################

# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call mult_big
  move $a0, $s4
  move $a1, $s4
  la $a2, bigint19            # initialize $s4 (bigint22)
  jal mult_big

# restore state
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

### copy output #######################

# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call copy_bigint
  move $a0, $v0
  move $a1, $s2
  jal copy_bigint

# restore state
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

########################################
### s = sub_big(s, two);
### ------------------------------------
### s := $s2
### two := $s5
########################################

### call subtraction ###################

# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call sub_big
  move $a0, $s2
  move $a1, $s5
  la $a2, bigint19            # initialize $s4 (bigint22)
  jal sub_big

# restore state
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

### copy output #######################

# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call copy_bigint
  move $a0, $v0
  move $a1, $s2
  jal copy_bigint

# restore state
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

########################################
### s = mod_big(s, Mp);
### ------------------------------------
### s := $s2
### Mp := $s1
########################################

### call modulus #######################

# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call mod_big
  move $a0, $s2
  move $a1, $s1
  la $a2, bigint19            # initialize $s4 (bigint22)
  jal sub_big

# restore state
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

### copy output #######################

# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call copy_bigint
  move $a0, $v0
  move $a1, $s2
  jal copy_bigint

# restore state
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

########################################
### for (int i = 0; i < p - 2; ++i) {}
### ------------------------------------
### i := $s3
### p-2 := $t9
########################################

  addi $s3, $s3, 1
  j LLT_loop

LLT_loop_exit:

########################################
### if (compare_big(s, zero) == 0) {}
### else {}
### ------------------------------------
### s := $s2
### zero := $s5
### compare_big(s, zero) == 0 := $t8
########################################

### call compare_big ###################

# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call compare_big
  move $a0, $s2
  move $a1, $s5
  jal compare_big

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# get return value
  move $t8, $v0

### branch and exit ###################

  beq $t8, $0, LLT_IF_1

########################################
### return 0
########################################

  li $v0, 0
  j LLT_RET

########################################
### return 1
########################################

LLT_IF_1:
  li $v1, 1
  j LLT_RET

LLT_RET:
# restore state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36             # 8 elements are popped from the stack

# return
  jr $ra



mod_big:
# save state
  addi $sp, $sp, -36          # 8 elements are pushed onto the stack
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

# read parameters
  move $s0, $a0               # $s0 is the starting address of a
  move $s1, $a1               # $s1 is the starting address of b
  move $s2, $a2               # $s2 is the starting address of c
  la $s3, bigint8             # $s4 is the starting address of original_b

# initialize c (by calling init_bigint)
# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call init_bigint
  move $a0, $s2
  jal init_bigint

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# store the denominator b (in bigint8)
# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call copy_bigint
  move $a0, $s1
  move $a1, $s3             # bigint8 stores original_b
  jal copy_bigint

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# prepare for loop
  li $t0, 1                   # $t0 = 1, which is compare_big(a,b)
  li $t9, 1                   # $t9 = 1, comparator

MOD_loop1:
# call compare_big and loop
# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call compare_big
  move $a0, $s0
  move $a1, $s1
  jal compare_big

# restore state
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

  move $t0, $v0               # get return value

  bne $t0, $t9, MOD_loop1_end # branch if compare_big(a,b) != 1

# call shift_right
# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call shift_right
  move $a0, $s1
  jal shift_right

# restore state
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

# continue loop
  j MOD_loop1

MOD_loop1_end:
# call shift left
# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call shift_left
  move $a0, $s1
  jal shift_left

# restore state
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

# prepare for the nested loop call
  li $t9, -1                   # $t9 = -1, comparator

MOD_loop2:
# call compare_big and loop
# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call compare_big
  move $a0, $s1
  move $a1, $s3
  jal compare_big

# restore state
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

  move $t0, $v0               # get return value in $t0

  beq $t0, $t9, MOD_return    # branch if compare_big(b,original_b) == -1

MOD_loop2_in:
# save state
  addi $sp, $sp, -24          # 4 elements are pushed onto the stack
  sw $t0, 20($sp)
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call compare_big
  move $a0, $s0
  move $a1, $s1
  jal compare_big

# restore state
  lw $t0, 20($sp)
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 24

  move $t1, $v0               # get return value in $t1

  beq $t1, $t9, MOD_loop2_in_end    # branch if compare_big(a,b) == -1

# call sub_big
# save state
  addi $sp, $sp, -24          # 4 elements are pushed onto the stack
  sw $t0, 20($sp)
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call sub_big
  move $a0, $s0
  move $a1, $s1
  move $a2, $s2
  jal sub_big

# restore state
  lw $t0, 20($sp)
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 24

# call copy_big
# save state
  addi $sp, $sp, -24          # 4 elements are pushed onto the stack
  sw $t0, 20($sp)
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call copy_bigint
  move $a0, $s2
  move $a1, $s0
  jal copy_bigint

# restore state
  lw $t0, 20($sp)
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 24

  j MOD_loop2_in

MOD_loop2_in_end:
# call shift_left
# save state
  addi $sp, $sp, -24          # 4 elements are pushed onto the stack
  sw $t0, 20($sp)
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call shift_left
  move $a0, $s1
  jal shift_left

# restore state
  lw $t0, 20($sp)
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 24

  j MOD_loop2

MOD_return:
# generate return value
  move $v0, $s0

# recover state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36           # 8 elements are popped from the stack

# return
  jr $ra


sub_big:
# save state
  addi $sp, $sp, -36          # 8 elements are pushed onto the stack
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

# read parameters
  move $s0, $a0               # $s0 is the starting address of a
  move $s1, $a1               # $s1 is the starting address of b
  move $s2, $a2               # $s2 is the starting address of c

# initialize c (by calling init_bigint)
# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call init_bigint
  move $a0, $s2
  jal init_bigint

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# c can have at most the number of digits in a
# c.n = a.n
  lw $t0, 0($s0)              # $t0 = a.n
  sw $t0, 0($s2)              # c.n = a.n

# initialization for c has been done in the previous step

# initialize carry
  li $s7, 0                   # $s7 is carry

# prepare for loop 1
  addi $s3, $s0, 4            # $s3 = &(a.digits[])
  addi $s4, $s1, 4            # $s4 = &(b.digits[])
  addi $s5, $s2, 4            # $s5 = &(c.digits[])
  lw $t9, 0($s1)              # $t9 = b.n
  li $s6, 0                   # $s7 = 0 (i)

SUB_loop1:
  bge $s6, $t9, SUB_loop1_end # branch if i>=b.n

  sll $t1, $s6, 2             # $t1 = 4i
  add $t2, $t1, $s3           # $t2 = &(a.digits[i])
  lw $t8, 0($t2)              # $t8 = a.digits[i]

  add $t2, $t1, $s4           # $t2 = &(b.digits[i])
  lw $t2, 0($t2)              # $t2 = b.digits[i]
  sub $t8, $t8, $t2           # $t8 = a.digits[i] - b.digits[i]

  add $t8, $t8, $s7           # $t8 = a.digits[i] - b.digits[i] + carry

  add $t2, $t1, $s5           # $t2 = &(c.digits[i])

  sw $t8, 0($t2)              # c.digits[i] = $t8

# if statement to check underflow
  blt $t8, $0, SUB_loop1_if   # branch if c.digits[i] <= 0 (optimized)
# if no
  li $s7, 0                   # carry = 0
  j SUB_loop1_if_end

SUB_loop1_if:
# if yes
  li $s7, -1                  # carry = -1
  addi $t8, $t8, 10           # $t8 += 10
  sw $t8, 0($t2)              # c.digits[i] += 10
  j SUB_loop1_if_end

SUB_loop1_if_end:
  addi $s6, $s6, 1            # ++i
  j SUB_loop1

SUB_loop1_end:
# check if a.n > b.n
  lw $t9, 0($s1)              # $t9 = b.n
  lw $t8, 0($s0)              # $t8 = a.n
  ble $t8, $t9, SUB_if_end    # branch if a.n <= b.n

  move $s6, $t9               # $s6 = b.n (i)

# loop through b.n through a.n-1
SUB_if_loop:
  bge $s6, $t8, SUB_if_end    # branch if i>= a.n

  sll $t1, $s6, 2             # $t1 = 4i
  add $t2, $t1, $s3           # $t2 = &(a.digits[i])
  lw $t7, 0($t2)              # $t7 = a.digits[i]

  add $t7, $t7, $s7           # $t7 = a.digits[i] + carry

  add $t2, $t1, $s5           # $t2 = &(c.digits[i])
  sw $t7, 0($t2)              # c.digits[i] = a.digits[i] + carry

SUB_if_if:
  blt $t7, $0, SUB_if_if_t    # branch if $t7 < 0
  li $s7, 0                   # carry = 0
  j SUB_if_if_end

SUB_if_if_t:
  li $s7, -1                  # carry = -1
  addi $t7, $t7, 10           # $t7 = $t7 + 10
  sw $t7, 0($t2)              # c.digits[i] += 10
  j SUB_if_if_end

SUB_if_if_end:
  addi $s6, $s6, 1            # i += 1
  j SUB_if_loop

SUB_if_end:
# call compress
  move $a0, $s2
  jal compress

SUB_return:
# generate return value
  move $v0, $s2

# restore state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36             # 8 elements are popped from the stack

# return
  jr $ra

compress:
  # save state
  addi $sp, $sp, -36          # 8 elements are pushed onto the stack
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

# read parameters
  move $s0, $a0               # $s0 is the starting address of a

# loop init
  lw $s7, 0($s0)
  addi $s7, $s7, -1           # $s7 = i (a->n-1)
  addi $s6, $s0, 4            # $s6 = &(a->digits[])
  ble $s7, $0, CPS_exit       # branch if i<=0

CPS_loop:
  move $t0, $s7               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4i
  add $t0, $s6, $t0           # $t0 = &a.digits[i]
  lw $t1, 0($t0)              # load a->digits[i] into $t1
  bne $t1, $0, CPS_exit       # branch if (a->digits[i] != 0)

  addi $s7, $s7, -1           # --i;
  ble $s7, $0, CPS_exit       # branch if i<=0
  j CPS_loop

CPS_exit:
  addi $s5, $s7, 1            # new size should be i+1 (since i is the index)
  sw $s5, 0($s0)              # update the new value to the memory address

CPS_return:
# recover state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36             # 8 elements are popped from the stack

# return
  jr $ra


# This function clears the memory of an uninitialized big int
# store bigint
init_bigint:
  move $t0, $a0                # t0 is the address of the first element (n)
  addi $t1, $t0, 1400          # t1 is the (word) address of the last element

init_loop:
  bgt $t0, $t1, init_exit      # if $t0 > $t1, branch to exit
  sw $0, 0($t0)                # arr[$t0] = 0
  addi $t0, $t0, 4             # $t0 += 4 (go to next element)
  j init_loop

init_exit:
# return (no return value)
  jr $ra


print_big:
# save state
  addi $sp, $sp, -36          # 8 elements are pushed onto the stack
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

# read parameters
  move $s0, $a0               # $s0 is the starting address of b

# loop init
  lw $s7, 0($s0)
  addi $s7, $s7, -1           # $s7 = c (b.n-1)
  addi $s6, $s0, 4            # $s6 = &b.digits[]
  blt $s7, $0, PG_exit        # branch if c<0

# loop
BG_loop:
  move $t0, $s7               # $t0 = c
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4c
  add $t0, $s6, $t0           # $t0 = &b.digits[c]
  lw $a0, 0($t0)              # load b.digits[c]
  li $v0, 1                   # load print sys call
  syscall                     # print element
  addi $s7, $s7, -1           # $s7 = $s7 - 1
  blt $s7, $0, PG_exit        # branch if c<0
  j BG_loop

# end of loop (print newline)
PG_exit:
  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

PG_return:
# recover state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36           # 8 elements are popped from the stack

# return
  jr $ra

shift_left:
# save state
  addi $sp, $sp, -36          # 8 elements are pushed onto the stack
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

# read parameters
  move $s0, $a0               # $s0 is the starting address of the bigint a

# loop init
  li $s7, 0                   # $s7 = i (0)
  lw $t9, 0($s0)
  addi $t9, $t9, -1           # $t9 = a->n - 1
  addi $s6, $s0, 4            # $s6 = &(a->digits[]), starting address of array
  bge $s7, $t9, SL_exit       # branch if i >= a->n-1

SL_loop:
  move $t0, $s7               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4i
  add $t0, $s6, $t0           # $t0 = &a.digits[i]
  lw $t1, 4($t0)              # load a->digits[i+1] into $t1
  sw $t1, 0($t0)              # a->digits[i] = a->digits[i+1]

  addi $s7, $s7, 1            # ++i;
  bge $s7, $t9, SL_exit       # branch if i >= a->n-1
  j SL_loop

SL_exit:
  move $t0, $t9               # $t0 = a->n - 1
  sll $t0, $t0, 2             # $t0 * 4
  add $t0, $s6, $t0           # $t0 = &a->digits[a->n-1]
  sw $0, 0($t0)               # a->digits[a->n-1] = 0；
  lw $s5, 0($s0)              # $s5 = a->n;
  addi $s5, $s5, -1           # $s5 -= 1;
  sw $s5, 0($s0)              # a->n = $s5 (a->n -= 1);

# call compress
# since end of function, we do not care whether $t0 and $t1 is rewritten
  move $a0, $s0               # fill arguments
  jal compress                # call compress

SL_return:
# recover state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36           # 8 elements are popped from the stack

# return
  jr $ra

shift_right:
# save state
  addi $sp, $sp, -36          # 8 elements are pushed onto the stack
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

# read parameters
  move $s0, $a0               # $s0 is the starting address of a

# loop init
  lw $s7, 0($s0)              # $s7 = i (a->n)
  addi $s6, $s0, 4            # $s6 = &(a->digits[])
  ble $s7, $0, SR_exit        # branch if i<=0

SR_loop:
  move $t0, $s7               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4i
  add $t0, $s6, $t0           # $t0 = &a.digits[i]
  lw $t1, -4($t0)             # load a->digits[i-1] into $t1
  sw $t1, 0($t0)              # a->digits[i] = a->digits[i-1]

  addi $s7, $s7, -1           # --i;
  ble $s7, $0, SR_exit        # branch if i<=0
  j SR_loop

SR_exit:
  sw $0, 4($s0)              # a->digits[0] = 0;
  lw $s7, 0($s0)             # $s7 = a->n;
  addi $s7, $s7, 1           # $s7 += 1;
  sw $s7, 0($s0)             # a->n = $s7 (a->n+=1);

SR_return:
  # recover state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36           # 8 elements are popped from the stack

# return
  jr $ra

compare_big:
# save state
  addi $sp, $sp, -36          # 8 elements are pushed onto the stack
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

# read parameters
  move $s0, $a0               # $s0 is the starting address of a
  move $s1, $a1               # $s1 is the starting address of b

# compare the size of a and b
  lw $s7, 0($s0)              # $s7 = a->n
  lw $s6, 0($s1)              # $s6 = b->n
  blt $s7, $s6, CB_exit1      # if a->n < b->n, return -1
  bgt $s7, $s6, CB_exit2      # if a->n > b->n, return 1

# loop init
  addi $s2, $s0, 4            # $s2 = &a->digits[]
  addi $s3, $s1, 4            # $s3 = &b->digits[]
  addi $s4, $s7, -1           # $s4 = i (a.n-1)
  blt $s4, $0, CB_exit3       # branch if i<0

CB_loop:
  move $t0, $s4               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4i
  add $t1, $s2, $t0           # $t1 = &a->digits[i]
  lw $t3, 0($t1)              # $t3 = a->digits[i]
  add $t2, $s3, $t0           # $t2 = &b->digits[i]
  lw $t4, 0($t2)              # $t4 = b->digits[i]
  blt $t3, $t4, CB_exit1      # branch if a->digits[i] < b->digits[i]
  bgt $t3, $t4, CB_exit2      # branch if a->digits[i] > b->digits[i]

  addi $s4, $s4, -1           # --i;
  blt $s4, $0, CB_exit3       # branch if i<0
  j CB_loop

CB_exit1:
  li $v0, -1                  # return -1
  j CB_return

CB_exit2:
  li $v0, 1                   # return 1
  j CB_return

CB_exit3:
  li $v0, 0                   # return 0

CB_return:
# recover state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36           # 8 elements are popped from the stack

# return
  jr $ra


# This function copies the data from one bigint to the other
# copy bigint
copy_bigint:
# save state
  addi $sp, $sp, -36          # 8 elements are pushed onto the stack
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

# prepare loop
  move $s0, $a0                 # s0 is the starting address of a
  addi $s1, $s0, 1400           # s1 is the (word) address of the last element
  move $s2, $a1                 # s2 is the starting address of b

copy_loop:
  bgt $s0, $s1, copy_exit       # if $s0 > $s1, branch to exit
  lw $s7, 0($s0)                # load a[i]
  sw $s7, 0($s2)                # save a[i]
  addi $s0, $s0, 4
  addi $s2, $s2, 4
  j copy_loop

copy_exit:
# recover state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36           # 8 elements are popped from the stack

# return (no return value)
  jr $ra

pow_big:
# save state
  addi $sp, $sp, -36          # 8 elements are pushed onto the stack
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

# read parameters
  move $s0, $a0               # $s0 is the starting address of a
  move $s1, $a1               # $s1 is integer p
  move $s2, $a2               # $s2 is the starting address of b

# initialize b (by calling copy_bigint)
# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call copy_bigint
  move $a0, $s0
  move $a1, $s2
  jal copy_bigint

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# initialize t (by calling init_bigint)
# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# t9 is the temporary bigint
# call init_bigint
  la $t9, bigint9
  move $a0, $t9
  jal init_bigint

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# prepare for loop
  li $s7, 1                   # $s7 = 1 (i)

POW_loop:
  bge $s7, $s1, POW_return    # branch to exit if i >= p

# call mult_big (and copy c to b)
# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $a0, 16($sp)
  sw $a1, 12($sp)
  sw $a2, 8($sp)
  sw $a3, 4($sp)
  sw $t9, 0($sp)

# call mult_big
  move $a0, $s0
  move $a1, $s2
  move $a2, $t9               # $t9 gets initialized in this call (no worry of garbage)
  jal mult_big

# restore state
  lw $a0, 16($sp)
  lw $a1, 12($sp)
  lw $a2, 8($sp)
  lw $a3, 4($sp)
  lw $t9, 0($sp)
  addi $sp, $sp, 20

# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $a0, 16($sp)
  sw $a1, 12($sp)
  sw $a2, 8($sp)
  sw $a3, 4($sp)
  sw $t9, 0($sp)

# call copy_bigint
  move $a0, $t9
  move $a1, $s2
  jal copy_bigint

# restore state
  lw $a0, 16($sp)
  lw $a1, 12($sp)
  lw $a2, 8($sp)
  lw $a3, 4($sp)
  lw $t9, 0($sp)
  addi $sp, $sp, 20

  addi $s7, $s7, 1           # increment i
  j POW_loop

POW_return:
# add return value
  move $v0, $s2

# recover state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36           # 8 elements are popped from the stack

# return
  jr $ra

mult_big:
# save state
  addi $sp, $sp, -36          # 8 elements are pushed onto the stack
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

# read parameters
  move $s0, $a0               # $s0 is the starting address of a
  move $s1, $a1               # $s1 is the starting address of b
  move $s2, $a2               # $s2 is the starting address of c

# initialize c (by calling init_bigint)
# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call init_bigint
  move $a0, $s2
  jal init_bigint

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16


# c can have at most the number of digits in a and b
# c.n = a.n + b.n
  lw $t0, 0($s0)              # $t0 = a.n
  lw $t1, 0($s1)              # $t1 = b.n
  add $t2, $t0, $t1           # $t2 = a.n + b.n
  sw $t2, 0($s2)              # c.n = a.n + b.n

# initialization for c has been done in the previous step

# prepare for loop
  addi $s3, $s0, 4            # $s3 = &(a.digits[])
  addi $s4, $s1, 4            # $s4 = &(b.digits[])
  addi $s5, $s2, 4            # $s5 = &(c.digits[])
  li $s7, 0                   # $s7 = 0 (i)

MUL_loop_out:
  bge $s7, $t1, MUL_end       # branch to end if $s7 (i) >= $t1 (b.n)

  li $t3, 0                   # $t3 = 0 (carry)
  move $s6, $s7               # $s6 = i (j)
  add $t9, $t0, $s7           # $t9 = a.n + i (used to condition)

MUL_loop_in:
  bge $s6, $t9, MUL_iend      # branch if j >= a.n+i

  # (define) t8 is *val*

  sll $t4, $s7, 2             # $t4 = $s7*4 (4i)
  add $t4, $s4, $t4           # $t4 = &(b.digits[i])
  lw $t8, 0($t4)              # $t8 = b.digits[i]

  sub $t4, $s6, $s7           # $t4 = $s6 - $s7 (j-i)
  sll $t4, $t4, 2             # $t4 = 4(j-i)
  add $t4, $s3, $t4           # $t4 = &(a.digits[j-i])
  lw $t4, 0($t4)              # $t4 = a.digits[j-i]
  mul $t8, $t8, $t4           # $t8 = b.digits[i] * a.digits[j-i]

  sll $t4, $s6, 2             # $t4 = $s6*4 (4j)
  add $t4, $s5, $t4           # $t4 = $s5 + $t4 = &(c.digits[j])
  lw $t5, 0($t4)              # $t5 = c.digits[j], $t4 = &(c.digits[j])
  add $t8, $t8, $t5           # $t8 = b.digits[i] * a.digits[j-i] + c.digits[j]

  add $t8, $t8, $t3           # $t8 = b.digits[i] * a.digits[j-i] + c.digits[j] + carry

# val div (mod) 10
  li $t5, 10                  # $t5 = 10
  div $t8, $t5
  mflo $t3                    # $t3 = val / 10
  mfhi $t5                    # $t5 = val % 10
  sw $t5, 0($t4)              # c.digits[j] = val % 10

# increment j and go to next iteration
  addi $s6, $s6, 1            # $j += 1
  j MUL_loop_in

MUL_iend:
  ble $t3, $0, MUL_iloop_end  # branch if $t3 (carry) <= 0

  sll $t4, $s6, 2             # $t4 = 4j
  add $t4, $s5, $t4          # $t4 = &(c.digits[j])
  lw $t5, 0($t4)              # $t5 = c.digits[j]
  add $t8, $t5, $t3           # val = c.digits[j] + carry

  li $t5, 10                  # $t5 = 10
  div $t8, $t5
  mflo $t3                    # $t3 = val / 10
  mfhi $t5                    # $t5 = val % 10
  sw $t5, 0($t4)              # c.digits[j] = val % 10

MUL_iloop_end:
  addi $s7, $s7, 1            # i += 1
  j MUL_loop_out              # go to the next out loop

MUL_end:
# Trim the leading zeros
# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call compress
  move $a0, $s2
  jal compress

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# put return value
  move $v0, $a2

# memory is updated in place, return
MUL_return:
# recover state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36           # 8 elements are popped from the stack

# return
  jr $ra


#################################
### test driver
#################################
main:

# print test notification
  la $a0, test_k
  li $v0, 4
  syscall

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

#################################
### Test p=11 for Mp primacy
#################################

# test case 1 (11)
  li $a0, 11
  jal LLT

# get return value and print
  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

  # exit (from main)
  li $v0, 10                 # load exit syscall code
  syscall                    # exit
