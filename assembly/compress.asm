# compress.asm

  .data
PROMPT_COMPRESS:  .asciiz "Compress Tests\n"
newline: .asciiz "\n"
.align 2
Bigint_tmp1:  .space  1404

  .text

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
  addi $sp, $sp, 36             # 8 elements are popped from the stack

##########################################################
### Exit function
##########################################################

  jr $ra


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
### Function: init_bigint
###-------------------------------------------------------
### % Code Segment %
### (1) void init_bigint(Bigint *a) {
### (2)   for (int i = a; i < a+1400; ++i)
### (3)     *a = 0;
### (4) }
###-------------------------------------------------------
### % Variable Table %
###   p                :=   $s0
###   i                :=   $s7
###   a->digits        :=   $s6
###   &(a->digits[i])  :=   $t0
###   a->digits[i]     :=   $t1
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
### Print "Small Prime Tests\n"
##########################################################

  la $a0, PROMPT_COMPRESS
  li $v0, 4
  syscall

##########################################################
### Tests compress(0003), exptects 3
##########################################################

# init bigint
  la $a0, Bigint_tmp1         # $a0 is the starting address of bigint1
  jal init_bigint

# load bigint
  li $t1, 4
  sw $t1, 0($a0)              # Bigint size is 4

  li $t1, 0
  sw $t1, 16($a0)             # first digit is 0
  li $t1, 0
  sw $t1, 12($a0)             # second digit is 0
  li $t1, 0
  sw $t1, 8($a0)              # third digit is 0
  li $t1, 3
  sw $t1, 4($a0)              # last digit is 3

# call compress
  jal compress

# call print_big
  jal print_big

##########################################################
### Exit the program
##########################################################

# exit (from main)
  li $v0, 10                 # load exit syscall code
  syscall                    # exit
