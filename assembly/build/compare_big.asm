# compare_big.asm

  .data
PROMPT_CMP:  .asciiz    "Comparison Tests\n"
newline:     .asciiz    "\n"
.align 2
Bigint_tmp1:  .space  1404
.align 2
Bigint_tmp2:  .space  1404

  .text

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




# test driver
main:

##########################################################
### Print "Comparison Tests\n\n"
##########################################################
  la $a0, PROMPT_CMP
  li $v0, 4
	syscall

##########################################################
### Tests case 1, compare_big(42,30), exptects 1
##########################################################

# init bigint1
  la $a0, Bigint_tmp1            # $a0 is the starting address of Bigint_tmp1
  jal init_bigint                # initialize Bigint_tmp1

# load bigint1
  li $t1, 2
  sw $t1, 0($a0)            # Bigint size is 2

  li $t1, 4
  sw $t1, 8($a0)            # first digit is 4
  li $t1, 2
  sw $t1, 4($a0)            # second digit is 2

# init bigint 2
  la $a0, Bigint_tmp2           # $a0 is the starting address of Bigint_tmp2
  jal init_bigint               # initialize Bigint_tmp2

# load bigint 2
  li $t1, 2
  sw $t1, 0($a0)            # Bigint size is 2

  li $t1, 3
  sw $t1, 8($a0)            # first digit is 3
  li $t1, 0
  sw $t1, 4($a0)            # second digit is 0

# call compare_big
# first case
  la $a0, Bigint_tmp1
  la $a1, Bigint_tmp2
  jal compare_big

  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

##########################################################
### Tests case 2, compare_big(30,42), exptects -1
##########################################################

  la $a0, Bigint_tmp2
  la $a1, Bigint_tmp1
  jal compare_big

  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

##########################################################
### Tests case 2, compare_big(42,42), exptects 0
##########################################################

# third case
  la $a0, Bigint_tmp1
  la $a1, Bigint_tmp1
  jal compare_big

  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

##########################################################
### Exit the program
##########################################################

# exit (from main)
  li $v0, 10                 # load exit syscall code
  syscall                    # exit
