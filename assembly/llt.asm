# llt.asm

  .data
PROMPT_LLT:   .asciiz "LLT Tests\n"
newline:      .asciiz "\n"
.align 2
Bigint_tmp1:  .space  1404
.align 2
Bigint_tmp2:  .space  1404
.align 2
Bigint_tmp3:  .space  1404
.align 2
Tmp_pow:  .space  1404
.align 2
Mod_tmp:  .space  1404
.align 2
LLT_0:  .space  1404
.align 2
LLT_1:  .space  1404
.align 2
LLT_2:  .space  1404
.align 2
LLT_s:  .space 1404
.align 2
LLT_Mp: .space 1404
.align 2
LLT_Mp2:  .space 1404
.align 2
LLT_tmp:  .space 1404

  .text
  la $s4, LLT_Mp           # store a copy of Mp

##########################################################
### Function: LLT
###-------------------------------------------------------
### % Code Segment %
### (1)  int LLT(int p) {
### (2)  	Bigint zero = digit_to_big(0);
### (3)  	Bigint one  = digit_to_big(1);
### (4) 	Bigint two  = digit_to_big(2);
### (5)
### (6) 	Bigint Mp = pow_big(two, p);
### (7) 	Mp =  sub_big(Mp, one);
###
### (8) 	Bigint s = digit_to_big(4);
###
### (9) 	for (int i = 0; i < p - 2; ++i) {
### (10) 		s = mult_big(s, s);
### (11) 		s = sub_big(s, two);
### (12) 		s = mod_big(s, Mp);
### (13) 	}
###
### (14) 	if (compare_big(s, zero) == 0)
### (15) 		return 1;
### (16) 	else
### (17) 		return 0;
### (18) }
###-------------------------------------------------------
### % Variable Table %
###     p    := $s0
###     Mp   := $s1
###     s    := $s2
###     i    := $s3
###     two  := $s5
###     one  := $s6
###     zero := $s7
###-------------------------------------------------------
### This function will update a and b in place
##########################################################

LLT:

##########################################################
### Function call: save state
##########################################################

  addi $sp, $sp, -36
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
### initialize temporary variables
########################################

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  la $a0, LLT_tmp
  jal init_bigint

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  la $a0, LLT_Mp2
  jal init_bigint

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

########################################
### (1)  int LLT(int p) {}
### ------------------------------------
###   p := $s0
########################################

# read parameters
  move $s0, $a0               # $s0 is p

########################################
### (2)  	Bigint zero = digit_to_big(0);
### ------------------------------------
### zero := $s7
########################################

  la $s7, LLT_0            # $s7 stores the starting address of 0

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  move $a0, $s7
  jal init_bigint

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# fill value
  li $t0, 1
  sw $t0, 0($s7)              # size of "0" is 1
  li $t0, 0
  sw $t0, 4($s7)              # the digit of "0" is 0

########################################
### (3)  	Bigint one  = digit_to_big(1);
### ------------------------------------
###   one := $s6
########################################

  la $s6, LLT_1            # $s6 stores the starting address of LLT_1

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  move $a0, $s6               # initialize $s6
  jal init_bigint

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# fill value
  li $t0, 1
  sw $t0, 0($s6)              # size of "1" is 1
  li $t0, 1
  sw $t0, 4($s6)              # the digit of "1" is 1

########################################
### (4) 	Bigint two  = digit_to_big(2);
### ------------------------------------
###   two := $s5
########################################

  la $s5, LLT_2            # $s6 stores the starting address of 2

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  move $a0, $s5               # initialize $s5
  jal init_bigint

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# fill value
  li $t0, 1
  sw $t0, 0($s5)              # size of "2" is 1
  li $t0, 2
  sw $t0, 4($s5)              # the digit of "2" is 2

########################################
### (6) 	Bigint Mp = pow_big(two, p);
### ------------------------------------
###   p   := $s0
###   Mp  := $s1
###   two := $s5
########################################

### Initialize Memory ##################

  la $s1, LLT_Mp              # $s1 stores the starting address of Mp

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  move $a0, $s1               # initialize $s1
  jal init_bigint

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  move $a0, $s5               # arg1: 2
  move $a1, $s0               # arg2: p
  move $a2, $s1               # arg3: Mp
  jal pow_big

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# get return value
  move $s1, $v0               # $s1 is Mp

########################################
### (7) 	Mp =  sub_big(Mp, one);
### ------------------------------------
###   Mp := $s1
###   one := $6
########################################

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call sub_big
#**#######################################################

  move $a0, $s1               # arg1: Mp
  move $a1, $s6               # arg2: 1 (bigint)
  la $a2, LLT_tmp             # arg3: tmp
  jal sub_big

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

### Get return value and copy to Mp ######################

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call copy_bigint
#**#######################################################

  move $a0, $v0
  move $a1, $s1
  jal copy_bigint

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

########################################
### (8) 	Bigint s = digit_to_big(4);
### ------------------------------------
### s := $s2
########################################

### Initialize s #########################################

  la $s2, LLT_s

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  move $a0, $s2               # initialize $s2 (LLT_s)
  jal init_bigint

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# fill value
  li $t0, 1
  sw $t0, 0($s2)              # size of "4" is 1
  li $t0, 4
  sw $t0, 4($s2)              # the digit of "4" is 4

########################################
### (9) 	for (int i = 0; i < p - 2; ++i) {
### ------------------------------------
###   p   := $s0
###   i   := $s3
###   p-2 := $t9
########################################

  li $s3, 0                   # $s3 is i (0)
  addi $t9, $s0, -2           # $t9 = p-2

LLT_loop:
  bge $s3, $t9, LLT_loop_exit # branch if i >= p-2

########################################
### (10) 		s = mult_big(s, s);
### ------------------------------------
### s := $s2
########################################


### Call multiplication ##################################

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -20
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call mult_big
#**#######################################################

  move $a0, $s2
  move $a1, $s2
  la $a2, LLT_tmp
  jal mult_big

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

### Copy Output ##########################################

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call copy_bigint
#**#######################################################

  move $a0, $v0
  move $a1, $s2
  jal copy_bigint

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

########################################
### (11) 		s = sub_big(s, two);
### ------------------------------------
###   s := $s2
###   two := $s5
########################################

### call subtraction #####################################

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -20
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call sub_big
#**#######################################################

  move $a0, $s2
  move $a1, $s5
  la $a2, LLT_tmp
  jal sub_big

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

### copy output #########################################

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -20
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call copy_bigint
#**#######################################################

  move $a0, $v0
  move $a1, $s2
  jal copy_bigint

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

########################################
### (12) 		s = mod_big(s, Mp);
### ------------------------------------
### s := $s2
### Mp := $s1, $s4 (copy)
########################################

### call modulus ########################################

### create a copy of $s1 (Mp) ###########################

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call copy_bigint
#**#######################################################

  move $a0, $s1
  la $a1, LLT_Mp2
  jal copy_bigint

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

### Call mod_big #########################################

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -20
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call mod_big
#**#######################################################

  move $a0, $s2
  la $a1, LLT_Mp2
  la $a2, LLT_tmp
  jal mod_big

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

### copy output #########################################

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -20
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call copy_bigint
#**#######################################################

  move $a0, $v0
  move $a1, $s2
  jal copy_bigint

#**#######################################################
#** Function call: restore state
#**#######################################################

  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

########################################
### (9) 	for (int i = 0; i < p - 2; ++i) {
### ------------------------------------
###   i := $s3
###   p-2 := $t9
########################################

  addi $s3, $s3, 1
  j LLT_loop

LLT_loop_exit:

########################################
### (14) 	if (compare_big(s, zero) == 0)
###       else {}
### ------------------------------------
###   s := $s2
###   zero := $s5
###   compare_big(s, zero) == 0 := $t8
########################################

### call compare_big #####################################

#**#######################################################
#** Function call: save state
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call compare_big
#**#######################################################

  move $a0, $s2
  move $a1, $s7
  jal compare_big

#**#######################################################
#** Function call: restore state
#**#######################################################

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
### (17) 		return 0;
########################################

  li $v0, 0
  j LLT_RET

########################################
### (15) 		return 1;
########################################

LLT_IF_1:
  li $v0, 1
  j LLT_RET

LLT_RET:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra


##########################################################
### Function: mod_big
###-------------------------------------------------------
### % Code Segment %
### (1)    Bigint mod_big(Bigint a, Bigint b) {
### (2)    	Bigint original_b = b;
### (3)    	while (compare_big(a, b) == 1)
### (4)    		shift_right(&b);
### (5)   	shift_left(&b);
### (6)    	while (compare_big(b,original_b) != -1)
### (7)    	{
### (8) 		  while (compare_big(a,b) != -1)
### (9)    			a = sub_big(a,b);
### (10)   		shift_left(&b);
### (11)   	}
### (12)  	return a;
### (13)  }
###-------------------------------------------------------
### % Variable Table %
###   a := $s0
###   b := $s1
###   c := $s2, c is an empty bigint
###   original_b := $s3
###-------------------------------------------------------
### This function will update a and b in place
##########################################################

mod_big:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1)    Bigint mod_big(Bigint a, Bigint b) {
###-------------------------------------------------------
###   a := $s0
###   b := $s1
###   c := $s2, c is an empty bigint
###   original_b := $s3
##########################################################

  move $s0, $a0               # $s0 is the starting address of a
  move $s1, $a1               # $s1 is the starting address of b
  move $s2, $a2               # $s2 is the starting address of c
  la $s3, Mod_tmp             # $s3 is the starting address of original_b

##########################################################
### Initialize the c
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  move $a0, $s2
  jal init_bigint

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

##########################################################
### (2)    	Bigint original_b = b;
###-------------------------------------------------------
###   b := $s1
###   original_b := $s3
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call copy_bigint
#**#######################################################

  move $a0, $s1
  move $a1, $s3
  jal copy_bigint

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

##########################################################
### (3)    	while (compare_big(a, b) == 1)
###-------------------------------------------------------
###   a                 := $s0
###   b                 := $s1
###   compare_big(a,b)  := $t0
###   1                 := $t9
##########################################################

  li $t0, 1                   # $t0 = 1, which is compare_big(a,b)
  li $t9, 1                   # $t9 = 1, comparator

MOD_loop1:

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call compare_big
#**#######################################################

  move $a0, $s0
  move $a1, $s1
  jal compare_big

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

  move $t0, $v0               # get return value

  bne $t0, $t9, MOD_loop1_end # branch if compare_big(a,b) != 1

##########################################################
### (4)    		shift_right(&b);
###-------------------------------------------------------
###   b := $s1
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -20
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call shift_right
#**#######################################################

  move $a0, $s1
  jal shift_right

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

# continue loop
  j MOD_loop1

MOD_loop1_end:

##########################################################
### (5)   	shift_left(&b);
###-------------------------------------------------------
###   b := $s1
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -20
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call shift_left
#**#######################################################

  move $a0, $s1
  jal shift_left

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

##########################################################
### (6)    	while (compare_big(b,original_b) != -1)
###-------------------------------------------------------
###   b           := $s1
###   original_b  := $s3
###   compare_big(b,original_b)  := $t0
###   -1          := $t9
##########################################################

  li $t9, -1                   # $t9 = -1, comparator

MOD_loop2:

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -20
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call compare_big
#**#######################################################

  move $a0, $s1
  move $a1, $s3
  jal compare_big

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

  move $t0, $v0               # get return value in $t0

  beq $t0, $t9, MOD_return    # branch if compare_big(b,original_b) == -1

MOD_loop2_in:

##########################################################
### (8) 		  while (compare_big(a,b) != -1)
###-------------------------------------------------------
###   a  := $s0
###   b  := $s1
###   compare_big(a.b)  := $t1
###   -1          := $t9
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -24
  sw $t0, 20($sp)
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call compare_big
#**#######################################################

  move $a0, $s0
  move $a1, $s1
  jal compare_big

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $t0, 20($sp)
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 24

  move $t1, $v0               # get return value in $t1

  beq $t1, $t9, MOD_loop2_in_end    # branch if compare_big(a,b) == -1

##########################################################
### (9)    			a = sub_big(a,b);
###-------------------------------------------------------
###   a  := $s0
###   b  := $s1
###   c  := $s2
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -24          # 4 elements are pushed onto the stack
  sw $t0, 20($sp)
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call sub_big
#**#######################################################

  move $a0, $s0
  move $a1, $s1
  move $a2, $s2
  jal sub_big

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $t0, 20($sp)
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 24

#**#######################################################
#** Move c to a
#**#######################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -24          # 4 elements are pushed onto the stack
  sw $t0, 20($sp)
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call copy_bigint
#**#######################################################

  move $a0, $s2
  move $a1, $s0
  jal copy_bigint

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $t0, 20($sp)
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 24

  j MOD_loop2_in

MOD_loop2_in_end:

##########################################################
### (10)   		shift_left(&b);
###-------------------------------------------------------
###   b  := $s1
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -24          # 4 elements are pushed onto the stack
  sw $t0, 20($sp)
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call shift_left
#**#######################################################

  move $a0, $s1
  jal shift_left

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $t0, 20($sp)
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 24

  j MOD_loop2

MOD_return:

##########################################################
### (12)  	return a;
###-------------------------------------------------------
###   b  := $s0
##########################################################

  move $v0, $s0

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra


  ##########################################################
  ### Function: sub_big
  ###-------------------------------------------------------
  ### % Code Segment %
  ### (1)   Bigint sub_big(Bigint a, Bigint b)
  ### (2)   {
  ### (3)     Bigint c;
  ### (4)     c.n = a.n;
  ### (5)   	for (int i = 0; i < c.n; ++i)
  ### (6)    		c.digits[i] = 0;
  ### (7)
  ### (8)    	int carry = 0;
  ### (9)   	for (int i = 0; i < b.n; ++i) {
  ### (10)  		c.digits[i] = a.digits[i] - b.digits[i] + carry;
  ### (11)   		if (c.digits[i] < 0) {
  ### (12)   			carry = -1;
  ### (13)   			c.digits[i] += 10;
  ### (14)   		} else
  ### (15)   			carry = 0;
  ### (16)   	}
  ### (17)
  ### (18)   	if (a.n > b.n) {
  ### (19)   		for (int i=b.n; i<a.n; ++i) {
  ### (20)  			c.digits[i] = a.digits[i] + carry;
  ### (21)   			if (c.digits[i]<0) {
  ### (22)   				carry = -1;
  ### (23)   				c.digits[i] += 10;
  ### (24)   			} else
  ### (25)   				carry = 0;
  ### (26)   		}
  ### (27)   	}
  ### (28)
  ### (29)   	compress(&c);
  ### (30)   	return c;
  ### (31)  }
  ###-------------------------------------------------------
  ### % Variable Table %
  ###   a := $s0
  ###   b := $s2
  ###   c := $s2, c is an empty bigint
  ###   &(a.digits[]) := $s3
  ###   &(b.digits[]) := $s4
  ###   &(c.digits[]) := $s5
  ###   i             := $s6
  ###   carry         := $s7
  ###   c.digits[i]   := $t8
  ###-------------------------------------------------------
  ### Since we cannot pow bigint in place, a temporary bigint
  ###   must be allocated to the function, which we call c
  ### That is, c is a pointer to an empty bigint
  ##########################################################

sub_big:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1)   Bigint sub_big(Bigint a, Bigint b)
###-------------------------------------------------------
###   a := $s0
###   b := $s1
###   c := $s2, c is an empty bigint
##########################################################

# read parameters
  move $s0, $a0               # $s0 is the starting address of a
  move $s1, $a1               # $s1 is the starting address of b
  move $s2, $a2               # $s2 is the starting address of c

##########################################################
### (3)     Bigint c;
### (5)   	for (int i = 0; i < c.n; ++i)
### (6)    		c.digits[i] = 0;
###-------------------------------------------------------
###   c := $s2, c is an empty bigint
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  move $a0, $s2
  jal init_bigint

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

##########################################################
### (4)     c.n = a.n;
###-------------------------------------------------------
###   a := $s0
###   c := $s2
##########################################################

  lw $t0, 0($s0)              # $t0 = a.n
  sw $t0, 0($s2)              # c.n = a.n

##########################################################
### (8)    	int carry = 0;
###-------------------------------------------------------
###   carry := $s7
##########################################################

  li $s7, 0                   # $s7 is carry


##########################################################
### (9)   	for (int i = 0; i < b.n; ++i) {
###-------------------------------------------------------
###   a             := $s0
###   b             := $s1
###   c             := $s2
###   &(a.digits[]) := $s3
###   &(b.digits[]) := $s4
###   &(c.digits[]) := $s5
###   i             := $s6
###   carry         := $s7
###   b.n           := $t9
##########################################################

# prepare for loop 1
  addi $s3, $s0, 4            # $s3 = &(a.digits[])
  addi $s4, $s1, 4            # $s4 = &(b.digits[])
  addi $s5, $s2, 4            # $s5 = &(c.digits[])
  lw $t9, 0($s1)              # $t9 = b.n
  li $s6, 0                   # $s7 = 0 (i)

SUB_loop1:
  bge $s6, $t9, SUB_loop1_end # branch if i>=b.n

##########################################################
### (10)  		c.digits[i] = a.digits[i] - b.digits[i] + carry;
###-------------------------------------------------------
###   &(a.digits[]) := $s3
###   &(b.digits[]) := $s4
###   &(c.digits[]) := $s5
###   i             := $s6
###   carry         := $s7
###   c.digits[i]   := $t8
##########################################################

  sll $t1, $s6, 2             # $t1 = 4i
  add $t2, $t1, $s3           # $t2 = &(a.digits[i])
  lw $t8, 0($t2)              # $t8 = a.digits[i]

  add $t2, $t1, $s4           # $t2 = &(b.digits[i])
  lw $t2, 0($t2)              # $t2 = b.digits[i]
  sub $t8, $t8, $t2           # $t8 = a.digits[i] - b.digits[i]

  add $t8, $t8, $s7           # $t8 = a.digits[i] - b.digits[i] + carry

  add $t2, $t1, $s5           # $t2 = &(c.digits[i])

  sw $t8, 0($t2)              # c.digits[i] = $t8

##########################################################
### (11)   		if (c.digits[i] < 0) {
###-------------------------------------------------------
###   c.digits[i]   := $t8
##########################################################

  blt $t8, $0, SUB_loop1_if   # branch if c.digits[i] <= 0 (optimized)

##########################################################
### (15)   			carry = 0;
###-------------------------------------------------------
###   carry         := $s7
##########################################################

  li $s7, 0                   # carry = 0
  j SUB_loop1_if_end

SUB_loop1_if:

##########################################################
### (12)   			carry = -1;
### (13)   			c.digits[i] += 10;
###-------------------------------------------------------
###   carry         := $s7
###   c.digits[i]   := $t8
##########################################################

  li $s7, -1                  # carry = -1

  addi $t8, $t8, 10           # $t8 += 10
  sw $t8, 0($t2)              # c.digits[i] += 10

  j SUB_loop1_if_end

SUB_loop1_if_end:

##########################################################
### (9)   	for (int i = 0; i < b.n; ++i) {
###-------------------------------------------------------
###   i             := $s6
##########################################################

  addi $s6, $s6, 1            # ++i
  j SUB_loop1

SUB_loop1_end:

##########################################################
### (18)   	if (a.n > b.n) {
###-------------------------------------------------------
###   a.n             := $t8
###   b.n             := $t9
##########################################################

  lw $t9, 0($s1)              # $t9 = b.n
  lw $t8, 0($s0)              # $t8 = a.n
  ble $t8, $t9, SUB_if_end    # branch if a.n <= b.n

##########################################################
### (19)   		for (int i=b.n; i<a.n; ++i) {
###-------------------------------------------------------
###   i               := $s6
###   a.n             := $t8
###   b.n             := $t9
##########################################################

  move $s6, $t9               # $s6 = b.n (i)

SUB_if_loop:
  bge $s6, $t8, SUB_if_end    # branch if i>= a.n

##########################################################
### (20)  			c.digits[i] = a.digits[i] + carry;
###-------------------------------------------------------
###   i                   := $s6
###   &(c.digits[i])      := $t2
###   a.digits[i] + carry := $t7
##########################################################

  sll $t1, $s6, 2             # $t1 = 4i
  add $t2, $t1, $s3           # $t2 = &(a.digits[i])
  lw $t7, 0($t2)              # $t7 = a.digits[i]

  add $t7, $t7, $s7           # $t7 = a.digits[i] + carry

  add $t2, $t1, $s5           # $t2 = &(c.digits[i])
  sw $t7, 0($t2)              # c.digits[i] = a.digits[i] + carry

##########################################################
### (21)   			if (c.digits[i]<0) {
###-------------------------------------------------------
###   c.digits[i]         := $t7
##########################################################

SUB_if_if:
  blt $t7, $0, SUB_if_if_t    # branch if $t7 < 0

##########################################################
### (25)   				carry = 0;
###-------------------------------------------------------
###   carry               := $s7
##########################################################

  li $s7, 0                   # carry = 0
  j SUB_if_if_end

SUB_if_if_t:

##########################################################
### (22)   				carry = -1;
### (23)   				c.digits[i] += 10;
###-------------------------------------------------------
###   carry               := $s7
###   c.digits[i]         := $t7
##########################################################

  li $s7, -1                  # carry = -1
  addi $t7, $t7, 10           # $t7 = $t7 + 10
  sw $t7, 0($t2)              # c.digits[i] += 10
  j SUB_if_if_end

SUB_if_if_end:

##########################################################
### (19)   		for (int i=b.n; i<a.n; ++i) {
###-------------------------------------------------------
###   i               := $s6
##########################################################

  addi $s6, $s6, 1            # i += 1
  j SUB_if_loop

SUB_if_end:

##########################################################
### (29)   	compress(&c);
###-------------------------------------------------------
###   c               := $s2
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call compress
#**#######################################################

  move $a0, $s2
  jal compress

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

SUB_return:

##########################################################
### (30)   	return c;
###-------------------------------------------------------
###   c               := $s2
##########################################################

  move $v0, $s2

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra



##########################################################
### Function: compress
###-------------------------------------------------------
### % Code Segment %
### (1) void compress(Bigint *a) {
### (2)   for (int i = a->n - 1; i > 0; --i) {
### (3)     if (a->digits[i] == 0)
### (4)       continue;
### (5)     else {
### (6)       a->n = i+1;
### (7)       return;
### (8)     }
### (9) 	}
### (10) }
###-------------------------------------------------------
### % Variable Table %
###   p                :=   $s0
###   i                :=   $s7
###   a->digits        :=   $s6
###   &(a->digits[i])  :=   $t0
###   a->digits[i]     :=   $t1
##########################################################

compress:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1) void compress(Bigint *a) {
###-------------------------------------------------------
### a := $s0
##########################################################

# read parameters
  move $s0, $a0               # $s0 is the starting address of a

##########################################################
### (2)   for (int i = a->n - 1; i > 0; --i) {
###-------------------------------------------------------
### p   :=  $s0
### i   :=  $s7
##########################################################

# initialize the loop
  lw $s7, 0($s0)
  addi $s7, $s7, -1           # $s7 = i (a->n-1)
  addi $s6, $s0, 4            # $s6 = &(a->digits[])
  ble $s7, $0, CPS_exit       # branch if i<=0

CPS_loop:

##########################################################
### (3)     if (a->digits[i] == 0)
###-------------------------------------------------------
### p                :=   $s0
### i                :=   $s7
### a->digits        :=   $s6
### &(a->digits[i])  :=   $t0
### a->digits[i]     :=   $t1
##########################################################

  move $t0, $s7               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4i
  add $t0, $s6, $t0           # $t0 = &a->digits[i]
  lw $t1, 0($t0)              # load a->digits[i] into $t1
  bne $t1, $0, CPS_exit       # branch if (a->digits[i] != 0)

##########################################################
### (2)   for (int i = a->n - 1; i > 0; --i) {
###
### (4)       continue;
###-------------------------------------------------------
### i   :=  $s7
##########################################################

  addi $s7, $s7, -1           # --i;
  ble $s7, $0, CPS_exit       # branch if i<=0
  j CPS_loop

CPS_exit:

##########################################################
### (6)       a->n = i+1;
### (7)       return;
###-------------------------------------------------------
### i   :=  $s7
##########################################################

  addi $s5, $s7, 1            # new size should be i+1 (since i is the index)
  sw $s5, 0($s0)              # update the new value to the memory address

CPS_return:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra

##########################################################
### Function: init_bigint
###-------------------------------------------------------
### % Code Segment %
### (1) void init_bigint(Bigint *a) {
### (2)   for (int i = a; i < a+1400; ++i)
### (3)     *a = 0;
### (4) }
###-------------------------------------------------------
### % Variable Table %
###   a       :=  $t0
###   a+1400  :=  $t1
##########################################################

init_bigint:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1) void init_bigint(Bigint *a) {}
###-------------------------------------------------------
### a := $t0
##########################################################

  move $t0, $a0                # t0 is the address of the first element (n)

##########################################################
### (2)   for (int i = a; i < a+1400; ++i)
###-------------------------------------------------------
### a       :=  $t0
### a+1400  :=  $t1
##########################################################

  addi $t1, $t0, 1400          # t1 is the (word) address of the last element

init_loop:
  bgt $t0, $t1, init_exit      # if $t0 > $t1, branch to exit

##########################################################
### (3)     *a = 0;
###-------------------------------------------------------
### a       :=  $t0
### a+1400  :=  $t1
##########################################################

  sw $0, 0($t0)                # arr[$t0] = 0

  addi $t0, $t0, 4             # $t0 += 4 (go to next element)
  j init_loop

init_exit:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra


##########################################################
### Function: print_big
###-------------------------------------------------------
### % code segment %
### (1) void print_big(Bigint b) {
### (2) 	for (int c = b.n-1; c>=0; --c)
### (3) 		printf("%d", b.digits[c]);
### (4) 	printf("\n");
### (5) }
###-------------------------------------------------------
### % Variable Table %
###   b   :=  $s0
###   c             :=  $s7
###   b.digits      :=  $s6
###   &b.digits[c]  :=  $t0
##########################################################

print_big:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1) void print_big(Bigint b) {}
###-------------------------------------------------------
### b := $s0
##########################################################

# read parameters
  move $s0, $a0               # $s0 is the starting address of b

##########################################################
### (2) 	for (int c = b.n-1; c>=0; --c)
###-------------------------------------------------------
### p         :=  $s0
### c         :=  $s7
### b.digits  :=  $s6
##########################################################

# initialize the loop
  lw $s7, 0($s0)
  addi $s7, $s7, -1           # $s7 = c (b.n-1)
  addi $s6, $s0, 4            # $s6 = &b.digits[]
  blt $s7, $0, PG_exit        # branch if c<0

# loop
BG_loop:

##########################################################
### (3) 		printf("%d", b.digits[c]);
###-------------------------------------------------------
### p             :=  $s0
### c             :=  $s7
### b.digits      :=  $s6
### &b.digits[c]  :=  $t0
##########################################################

  move $t0, $s7               # $t0 = c
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4c
  add $t0, $s6, $t0           # $t0 = &b.digits[c]
  lw $a0, 0($t0)              # load b.digits[c]
  li $v0, 1                   # load print sys call
  syscall                     # print element
  addi $s7, $s7, -1           # $s7 = $s7 - 1
  blt $s7, $0, PG_exit        # branch if c<0
  j BG_loop

##########################################################
### (4) 	printf("\n");
##########################################################

PG_exit:
  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

PG_return:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra


##########################################################
### Function: shift_left
###-------------------------------------------------------
### % Code Segment %
### (1) void shift_left(Bigint *a) {
### (2) 	for (int i=0; i<a->n-1; ++i)
### (3) 		a->digits[i] = a->digits[i+1];
### (4) 	a->digits[a->n-1] = 0;
### (5) 	--a->n;
### (6) 	compress(a);
### (7) }
###-------------------------------------------------------
### % Variable Table %
###   a                 := $s0
###   i                 := $s7
###   &(a->digits[])    := $s6
###   a->n              := $s5
###   &a.digits[i]      := $t0
###   a->digits[i+1]    := $t1
##########################################################

shift_left:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1) void shift_left(Bigint *a) { }
###-------------------------------------------------------
### a := $s0
##########################################################

# read parameters
  move $s0, $a0               # $s0 is the starting address of the bigint a

##########################################################
### (2) 	for (int i=0; i<a->n-1; ++i)
###-------------------------------------------------------
### a                 := $s0
### i                 := $s7
### &(a->digits[])    := $s6
### a->n-1            := $t9
##########################################################

# initialize the loop
  li $s7, 0                   # $s7 = i (0)
  lw $t9, 0($s0)
  addi $t9, $t9, -1           # $t9 = a->n - 1
  addi $s6, $s0, 4            # $s6 = &(a->digits[]), starting address of array
  bge $s7, $t9, SL_exit       # branch if i >= a->n-1

SL_loop:

##########################################################
### (3) 		a->digits[i] = a->digits[i+1];
###-------------------------------------------------------
### a                 := $s0
### i                 := $s7
### &(a->digits[])    := $s6
### &a.digits[i]      := $t0
### a->digits[i+1]    := $t1
##########################################################

  move $t0, $s7               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4i
  add $t0, $s6, $t0           # $t0 = &a.digits[i]
  lw $t1, 4($t0)              # load a->digits[i+1] into $t1
  sw $t1, 0($t0)              # a->digits[i] = a->digits[i+1]

##########################################################
### (2) 	for (int i=0; i<a->n-1; ++i)
###-------------------------------------------------------
### a                 := $s0
### i                 := $s7
### &(a->digits[])    := $s6
### a->n-1            := $t9
##########################################################

  addi $s7, $s7, 1            # ++i;
  bge $s7, $t9, SL_exit       # branch if i >= a->n-1
  j SL_loop

SL_exit:

##########################################################
### (4) 	a->digits[a->n-1] = 0;
### (5) 	--a->n;
###-------------------------------------------------------
### a                 := $s0
### i                 := $s7
### &(a->digits[])    := $s6
### a->n              := $s5
### &a.digits[i]      := $t0
### a->digits[i+1]    := $t1
##########################################################

  move $t0, $t9               # $t0 = a->n - 1
  sll $t0, $t0, 2             # $t0 * 4
  add $t0, $s6, $t0           # $t0 = &a->digits[a->n-1]
  sw $0, 0($t0)               # a->digits[a->n-1] = 0；
  lw $s5, 0($s0)              # $s5 = a->n;
  addi $s5, $s5, -1           # $s5 -= 1;
  sw $s5, 0($s0)              # a->n = $s5 (a->n -= 1);

##########################################################
### (6) 	compress(a);
###-------------------------------------------------------
### a                 := $s0
##########################################################

  move $a0, $s0               # fill arguments
  jal compress                # call compress

SL_return:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra


##########################################################
### Function: shift_right
###-------------------------------------------------------
### % Code Segment %
### (1) void shift_right(Bigint *a) {
### (2) 	for (int i = a->n; i>0; --i)
### (3) 		a->digits[i] = a->digits[i-1];
### (4) 	a->digits[0] = 0;
### (5) 	a->n += 1;
### (6) }
###-------------------------------------------------------
### % Variable Table %
###   a                 := $s0
###   i                 := $s7 - 1
###   &(a->digits[])    := $s6
###   &a.digits[i]      := $t0
###   a->digits[i-1]    := $t1
###   a->n              := $s7 - 2
##########################################################

shift_right:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1) void shift_right(Bigint *a) { }
###-------------------------------------------------------
### a := $s0
##########################################################

# read parameters
  move $s0, $a0               # $s0 is the starting address of a

##########################################################
### (2) 	for (int i = a->n; i>0; --i)
###-------------------------------------------------------
### a                 := $s0
### i                 := $s7
### &(a->digits[])    := $s6
##########################################################

# initialize the loop
  lw $s7, 0($s0)              # $s7 = i (a->n)
  addi $s6, $s0, 4            # $s6 = &(a->digits[])
  ble $s7, $0, SR_exit        # branch if i<=0

SR_loop:

##########################################################
### (3) 		a->digits[i] = a->digits[i-1];
###-------------------------------------------------------
### a                 := $s0
### i                 := $s7
### &(a->digits[])    := $s6
### &a.digits[i]      := $t0
### a->digits[i-1]    := $t1
##########################################################

  move $t0, $s7               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4i
  add $t0, $s6, $t0           # $t0 = &a.digits[i]
  lw $t1, -4($t0)             # load a->digits[i-1] into $t1
  sw $t1, 0($t0)              # a->digits[i] = a->digits[i-1]

##########################################################
### (2) 	for (int i = a->n; i>0; --i)
###-------------------------------------------------------
### i                 := $s7
##########################################################

  addi $s7, $s7, -1           # --i;
  ble $s7, $0, SR_exit        # branch if i<=0
  j SR_loop

SR_exit:

##########################################################
### (4) 	a->digits[0] = 0;
###-------------------------------------------------------
### a := $s0
##########################################################

  sw $0, 4($s0)              # a->digits[0] = 0;

##########################################################
### (5) 	a->n += 1;
###-------------------------------------------------------
### a := $s0
### a->n := $s7
##########################################################

  lw $s7, 0($s0)             # $s7 = a->n;
  addi $s7, $s7, 1           # $s7 += 1;
  sw $s7, 0($s0)             # a->n = $s7 (a->n+=1);

SR_return:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra

##########################################################
### Function: compare_big
###-------------------------------------------------------
### %   Code Segment %
### (1)   int compare_big(Bigint a, Bigint b) {
### (2)     if (a.n < b.n)
### (3)    		return -1;
### (4)   	if (a.n > b.n)
### (5)   		return 1;
### (6)    	for (int i = a.n-1; i>=0; --i) {
### (7)   		if (a.digits[i] > b.digits[i])
### (8)   			return 1;
### (9)    		else if (a.digits[i] < b.digits[i])
### (10)   			return -1;
### (11)   	}
### (12)   	return 0;
### (13)  }
###-------------------------------------------------------
### % Variable Table %
###   a             :=  $s0
###   b             :=  $s1
###   &a->digits[]  :=  $s2
###   &b->digits[]  :=  $s3
###   i             :=  $s4
###   b->n          :=  $s6
###   a->n          :=  $s7
###   &a->digits[i] :=  $t1
###   &b->digits[i] :=  $t2
###   a->digits[i]  :=  $t3
###   b->digits[i]  :=  $t4
##########################################################

compare_big:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1)   int compare_big(Bigint a, Bigint b) {
###-------------------------------------------------------
###   a := $s0
###   b := $s1
##########################################################

# read parameters
  move $s0, $a0               # $s0 is the starting address of a
  move $s1, $a1               # $s1 is the starting address of b

##########################################################
### (2)     if (a.n < b.n)
### ###
### (4)   	if (a.n > b.n)
###-------------------------------------------------------
###   a     :=  $s0
###   b     :=  $s1
###   a->n  :=  $s7
###   b->n  :=  $s6
##########################################################

# compare the size of a and b
  lw $s7, 0($s0)              # $s7 = a->n
  lw $s6, 0($s1)              # $s6 = b->n
  blt $s7, $s6, CB_exit1      # if a->n < b->n, return -1
  bgt $s7, $s6, CB_exit2      # if a->n > b->n, return 1

##########################################################
### (6)    	for (int i = a.n-1; i>=0; --i) { }
###-------------------------------------------------------
###   a             :=  $s0
###   b             :=  $s1
###   a->n          :=  $s7
###   b->n          :=  $s6
###   &a->digits[]  :=  $s2
###   &b->digits[]  :=  $s3
###   i             :=  $s4
##########################################################

# initialize the loop
  addi $s2, $s0, 4            # $s2 = &a->digits[]
  addi $s3, $s1, 4            # $s3 = &b->digits[]
  addi $s4, $s7, -1           # $s4 = i (a.n-1)
  blt $s4, $0, CB_exit3       # branch if i<0

CB_loop:

##########################################################
### (7)   		if (a.digits[i] > b.digits[i])
### ###
### (9)    		else if (a.digits[i] < b.digits[i])
###-------------------------------------------------------
###   a             :=  $s0
###   b             :=  $s1
###   a->n          :=  $s7
###   b->n          :=  $s6
###   &a->digits[]  :=  $s2
###   &b->digits[]  :=  $s3
###   i             :=  $s4
###   &a->digits[i] :=  $t1
###   &b->digits[i] :=  $t2
###   a->digits[i]  :=  $t3
###   b->digits[i]  :=  $t4
##########################################################

  move $t0, $s4               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4i
  add $t1, $s2, $t0           # $t1 = &a->digits[i]
  lw $t3, 0($t1)              # $t3 = a->digits[i]
  add $t2, $s3, $t0           # $t2 = &b->digits[i]
  lw $t4, 0($t2)              # $t4 = b->digits[i]
  blt $t3, $t4, CB_exit1      # branch if a->digits[i] < b->digits[i]
  bgt $t3, $t4, CB_exit2      # branch if a->digits[i] > b->digits[i]

##########################################################
### (6)    	for (int i = a.n-1; i>=0; --i) { }
###-------------------------------------------------------
###   i             :=  $s4
##########################################################

  addi $s4, $s4, -1           # --i;
  blt $s4, $0, CB_exit3       # branch if i<0
  j CB_loop

##########################################################
### (3)    		return -1;
### (10)   			return -1;
##########################################################

CB_exit1:
  li $v0, -1                  # return -1
  j CB_return

##########################################################
### (5)   		return 1;
### (8)   			return 1;
##########################################################

CB_exit2:
  li $v0, 1                   # return 1
  j CB_return

##########################################################
### (12)   	return 0;
##########################################################

CB_exit3:
  li $v0, 0                   # return 0

CB_return:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra

##########################################################
### Function: mult_big
###-------------------------------------------------------
### % Code Segment %
### (1)   Bigint mult_big(Bigint a, Bigint b) {
### (2)     Bigint c;
### (3)     c.n = a.n + b.n;
### (4)    	for (int i=0; i < c.n; ++i)
### (5)    		c.digits[i] = 0;
### (6)    	for (int i=0; i < b.n; ++i) {
### (7)    		int carry = 0;
### (8)    		int j;
### (9)
### (10)   		for (j=i; j < a.n+i; ++j) {
### (11) 	  		int val = c.digits[j] + (b.digits[i] * a.digits[j-i]) + carry;
### (12)  			carry       = val / 10;
### (13)   			c.digits[j] = val % 10;
### (14)   		}
### (15)
### (16)  		if (carry > 0) {
### (17)   			int val = c.digits[j] + carry;
### (18)  			carry       = val / 10;
### (19)  			c.digits[j] = val % 10;
### (20)   		}
### (21) 	  }
### (22) 	  compress(&c);
### (23)   	return c;
### (24) }
###-------------------------------------------------------
### % Variable Table %
###   a             := $s0
###   b             := $s1
###   c             := $s2, c is an empty bigint
###   &(a.digits[]) := $s3
###   &(b.digits[]) := $s4
###   &(c.digits[]) := $s5
###   j             := $s6
###   i             := $s7
###   a.n           := $t0
###   b.n           := $t1
###   c.n           := $t2
###   carry         := $t3
###   val           := $t8
###   a.n+i         := $t9
###-------------------------------------------------------
### Since we cannot mult bigint in place, a temporary bigint
###   must be allocated to the function, which we call c
### That is, c is a pointer to an empty bigint
##########################################################

mult_big:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1)   Bigint mult_big(Bigint a, Bigint b) { }
###-------------------------------------------------------
###   a := $s0
###   b := $s1
###   c := $s2, c is an empty bigint
##########################################################

# read parameters
  move $s0, $a0               # $s0 is the starting address of a
  move $s1, $a1               # $s1 is the starting address of b
  move $s2, $a2               # $s2 is the starting address of c (the return value)

##########################################################
### (2)     Bigint c;
###-------------------------------------------------------
###   c := $s2, c is an empty bigint
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  move $a0, $s2
  jal init_bigint

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

##########################################################
### (3)     c.n = a.n + b.n;
###-------------------------------------------------------
###   a   := $s0
###   b   := $s1
###   c   := $s2, c is an empty bigint
###   a.n := $t0
###   b.n := $t1
###   c.n := $t2
##########################################################

# c.n = a.n + b.n
  lw $t0, 0($s0)              # $t0 = a.n
  lw $t1, 0($s1)              # $t1 = b.n
  add $t2, $t0, $t1           # $t2 = a.n + b.n
  sw $t2, 0($s2)              # c.n = a.n + b.n

##########################################################
### (4)    	for (int i=0; i < c.n; ++i)
### (5)    		c.digits[i] = 0; (see (2))
##########################################################

# initialization for c has been done in the previous step

##########################################################
### (6)    	for (int i=0; i < b.n; ++i) { }
###-------------------------------------------------------
###   a             := $s0
###   b             := $s1
###   c             := $s2, c is an empty bigint
###   &(a.digits[]) := $s3
###   &(b.digits[]) := $s4
###   &(c.digits[]) := $s5
###   i             := $s7
###   b.n           := $t1
##########################################################

# prepare for loop
  addi $s3, $s0, 4            # $s3 = &(a.digits[])
  addi $s4, $s1, 4            # $s4 = &(b.digits[])
  addi $s5, $s2, 4            # $s5 = &(c.digits[])
  li $s7, 0                   # $s7 = 0 (i)

MUL_loop_out:
  bge $s7, $t1, MUL_end       # branch to end if $s7 (i) >= $t1 (b.n)

##########################################################
### (7)    		int carry = 0;
###-------------------------------------------------------
###   carry := $t3
##########################################################

  li $t3, 0                   # $t3 = 0 (carry)

##########################################################
### (8)    		int j;
###-------------------------------------------------------
###   j := $s6
##########################################################

  move $s6, $s7               # $s6 = i (j)

##########################################################
### (10)   		for (j=i; j < a.n+i; ++j) {
###-------------------------------------------------------
###   j             := $s6
###   i             := $s7
###   a.n           := $t0
###   a.n+i         := $t9
##########################################################

  add $t9, $t0, $s7           # $t9 = a.n + i (used to condition)

MUL_loop_in:
  bge $s6, $t9, MUL_iend      # branch if j >= a.n+i

##########################################################
### (11) 	  		int val = c.digits[j] + (b.digits[i] * a.digits[j-i]) + carry;
###-------------------------------------------------------
###   a             := $s0
###   b             := $s1
###   c             := $s2
###   &(a.digits[]) := $s3
###   &(b.digits[]) := $s4
###   &(c.digits[]) := $s5
###   j             := $s6
###   i             := $s7
###   carry         := $t3
###   val           := $t8
###   a.n+i         := $t9
##########################################################

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

##########################################################
### (12)  			carry       = val / 10;
###-------------------------------------------------------
###   carry         := $t3
###   &(c.digits[j]):= $t4
###   val           := $t8
###   a.n+i         := $t9
##########################################################

# val div (mod) 10
  li $t5, 10                  # $t5 = 10
  div $t8, $t5
  mflo $t3                    # $t3 = val / 10

##########################################################
### (13)   			c.digits[j] = val % 10;
###-------------------------------------------------------
###   carry         := $t3
###   &(c.digits[j]):= $t4
###   val           := $t8
###   a.n+i         := $t9
##########################################################

  mfhi $t5                    # $t5 = val % 10
  sw $t5, 0($t4)              # c.digits[j] = val % 10

##########################################################
### (10)   		for (j=i; j < a.n+i; ++j) {
###-------------------------------------------------------
###   j             := $s6
###   i             := $s7
###   a.n           := $t0
###   a.n+i         := $t9
##########################################################

# increment j and go to next iteration
  addi $s6, $s6, 1            # $j += 1
  j MUL_loop_in

MUL_iend:

##########################################################
### (16)  		if (carry > 0) {
###-------------------------------------------------------
###   carry := $t3
##########################################################

  ble $t3, $0, MUL_iloop_end  # branch if $t3 (carry) <= 0

##########################################################
### (17)   			int val = c.digits[j] + carry;
###-------------------------------------------------------
###   carry         := $t3
###   &(c.digits[j]):= $t4
###   val           := $t8
##########################################################

  sll $t4, $s6, 2             # $t4 = 4j
  add $t4, $s5, $t4           # $t4 = &(c.digits[j])
  lw $t5, 0($t4)              # $t5 = c.digits[j]
  add $t8, $t5, $t3           # val = c.digits[j] + carry

##########################################################
### (18)  			carry       = val / 10;
###-------------------------------------------------------
###   carry         := $t3
###   &(c.digits[j]):= $t4
###   val           := $t8
##########################################################

  li $t5, 10                  # $t5 = 10
  div $t8, $t5
  mflo $t3                    # $t3 = val / 10

##########################################################
### (19)  			c.digits[j] = val % 10;
###-------------------------------------------------------
###   carry         := $t3
###   &(c.digits[j]):= $t4
###   val           := $t8
##########################################################

  mfhi $t5                    # $t5 = val % 10
  sw $t5, 0($t4)              # c.digits[j] = val % 10

MUL_iloop_end:

##########################################################
### (6)    	for (int i=0; i < b.n; ++i) { }
###-------------------------------------------------------
###   i := $s7
##########################################################

  addi $s7, $s7, 1            # i += 1
  j MUL_loop_out              # go to the next out loop

MUL_end:

##########################################################
### (22) 	  compress(&c);
###-------------------------------------------------------
###   c := $s2
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  move $a0, $s2
  jal compress

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

##########################################################
### (23)   	return c;
###-------------------------------------------------------
###   c := $s2
##########################################################

  move $v0, $a2

MUL_return:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra

##########################################################
### Function: pow_big
###-------------------------------------------------------
### % Code Segment %
### (1)  Bigint pow_big(Bigint a, int p) {
### (2)  	Bigint b = a;
### (3)  	for (int i = 1; i < p; ++i)
### (4)  		b = mult_big(b, a);
### (5)  	return b;
### (6) }
###-------------------------------------------------------
### % Variable Table %
###   a       := $s0
###   p       := $s1
###   b       := $s2
###   i       := $s7
###   Tmp_pow := $t9
###-------------------------------------------------------
### Since we cannot pow bigint in place, a temporary bigint
###   must be allocated to the function, which we call b
### That is, b is a pointer to an empty bigint
##########################################################

pow_big:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1)  Bigint pow_big(Bigint a, int p) {
###-------------------------------------------------------
###   a := $s0
###   p := $s1
###   b := $s2, b is an empty bigint
##########################################################

# read parameters
  move $s0, $a0               # $s0 is the starting address of a
  move $s1, $a1               # $s1 is integer p
  move $s2, $a2               # $s2 is the starting address of b

##########################################################
### (2)  	Bigint b = a;
###-------------------------------------------------------
###   a := $s0
###   b := $s2
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call copy_bigint
#**#######################################################

  move $a0, $s0
  move $a1, $s2
  jal copy_bigint

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

##########################################################
### Initialize temporary variable in pow_big (Tmp_pow)
###-------------------------------------------------------
###   Tmp_pow := $t9
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  la $t9, Tmp_pow
  move $a0, $t9
  jal init_bigint

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

##########################################################
### (3)  	for (int i = 1; i < p; ++i)
###-------------------------------------------------------
###   p := $s1
###   i := $s7
##########################################################

# prepare for loop
  li $s7, 1                   # $s7 = 1 (i)

POW_loop:
  bge $s7, $s1, POW_return    # branch to exit if i >= p

##########################################################
### (4)  		b = mult_big(b, a);
###-------------------------------------------------------
###   a       := $s0
###   p       := $s1
###   b       := $s2
###   i       := $s7
###   Tmp_pow := $t9
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -20
  sw $a0, 16($sp)
  sw $a1, 12($sp)
  sw $a2, 8($sp)
  sw $a3, 4($sp)
  sw $t9, 0($sp)

#**#######################################################
#** Function call: call mult_big
#**#######################################################

  move $a0, $s0
  move $a1, $s2
  move $a2, $t9               # $t9 gets reinitialized in this call (no worry of garbage)
  jal mult_big

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 16($sp)
  lw $a1, 12($sp)
  lw $a2, 8($sp)
  lw $a3, 4($sp)
  lw $t9, 0($sp)
  addi $sp, $sp, 20

##########################################################
### copy $t9 back to b
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -20
  sw $a0, 16($sp)
  sw $a1, 12($sp)
  sw $a2, 8($sp)
  sw $a3, 4($sp)
  sw $t9, 0($sp)

#**#######################################################
#** Function call: call copy_bigint
#**#######################################################

  move $a0, $t9
  move $a1, $s2
  jal copy_bigint

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 16($sp)
  lw $a1, 12($sp)
  lw $a2, 8($sp)
  lw $a3, 4($sp)
  lw $t9, 0($sp)
  addi $sp, $sp, 20

##########################################################
### (3)  	for (int i = 1; i < p; ++i)
###-------------------------------------------------------
###   i := $s7
##########################################################

  addi $s7, $s7, 1           # increment i
  j POW_loop

POW_return:

##########################################################
### (5)  	return b;
###-------------------------------------------------------
###   i := $s7
##########################################################

  move $v0, $s2

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra


##########################################################
### Function: copy_bigint
###-------------------------------------------------------
### % Code Segment %
### (1) copy_bigint(Bigint *a, Bigint *b) {
### (2)   for (x=a, y=b; x<=350+a; ++x, ++y)
### (3)     *y = *x
### (4) }
###-------------------------------------------------------
### % Variable Table %
###   a             := $s0
###   b             := $s1
###   c             := $s2, c is an empty bigint
###   &(a.digits[]) := $s3
###   &(b.digits[]) := $s4
###   &(c.digits[]) := $s5
###   j             := $s6
###   i             := $s7
###   a.n           := $t0
###   b.n           := $t1
###   c.n           := $t2
###   carry         := $t3
###   val           := $t8
###   a.n+i         := $t9
##########################################################

copy_bigint:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1) copy_bigint(Bigint *a, Bigint *b) {
### (2)   for (x=a, y=b; x<=350+a; ++x, ++y)
###-------------------------------------------------------
###   x       :=  $s0
###   x+350   :=  $s1
###   y       :=  $s2
##########################################################

# Initialize Loop
  move $s0, $a0                 # s0 is the starting address of a
  addi $s1, $s0, 1400           # s1 is the (word) address of the last element
  move $s2, $a1                 # s2 is the starting address of b

copy_loop:
  bgt $s0, $s1, copy_exit       # if $s0 > $s1, branch to exit

##########################################################
### (3)     *y = *x
###-------------------------------------------------------
###   x       :=  $s0
###   y       :=  $s2
###   a[i]    :=  $s7
##########################################################

  lw $s7, 0($s0)                # load a[i]
  sw $s7, 0($s2)                # save a[i]

##########################################################
### (2)   for (x=a, y=b; x<=350+a; ++x, ++y)
###-------------------------------------------------------
###   x       :=  $s0
###   y       :=  $s2
##########################################################

  addi $s0, $s0, 4
  addi $s2, $s2, 4
  j copy_loop

copy_exit:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra




#################################
### test driver
#################################
main:

# print test notification
  la $a0, PROMPT_LLT
  li $v0, 4
  syscall

##########################################################
### Test case 1, 11, expects 0
##########################################################

  li $a0, 11
  jal LLT

# get return value and print
  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

##########################################################
### Test case 2, 61, expects 1
##########################################################

  li $a0, 61
  jal LLT

  # get return value and print
  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

##########################################################
### Exit the program
##########################################################

  li $v0, 10                 # load exit syscall code
  syscall                    # exit
