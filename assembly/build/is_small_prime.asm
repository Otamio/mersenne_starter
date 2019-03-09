# is_small_prime.asm

  .data
PROMPT_ISP:     .asciiz  "Small Prime Tests\n"
newline:        .asciiz   "\n"

  .text

##########################################################
### Function: is_small_prime
###-------------------------------------------------------
### % Code Segment %
### (1) int is_small_prime(int p) {
### (2)	  for (int i=2; i<p-1; ++i)
### (3) 		if (p%i == 0)
### (4) 			return 0;
### (5) 	return 1;
### (6) }
###-------------------------------------------------------
### % Variable Table %
###   p   :=  $s0
###   i   :=  $s7
###   p-1 :=  $t0
###   p%i :=  $t1
##########################################################

is_small_prime:

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
### (1) int is_small_prime(int p) {}
###-------------------------------------------------------
### p := $s0
##########################################################

# read parameters
  move $s0, $a0               # $s0 = p

##########################################################
### (2)	  for (int i=2; i<p-1; ++i)
###-------------------------------------------------------
### p   :=  $s0
### p-1 :=  $t0
### i   :=  $s7
##########################################################

# initialize the loop
  li $s7, 2                   # $s7 = i (2)
  addi $t0, $s0, -1           # $t0 = p-1
  slt $t9, $s7, $t0           # $t9 = $s7(i) < $t0(p-1)
  beq $t9, $0, ISP_exit2      # branch exit_a2 if $t9 is false

##########################################################
### (3) 		if (p%i == 0)
###-------------------------------------------------------
### p   :=  $s0
### i   :=  $s7
### p%i :=  $t1
##########################################################

ISP_loop:
  div $s0, $s7
  mfhi $t1                    # $t1 = p%i
  beq $t1, $0, ISP_exit1      # branch exit_a1 if $t1 is 0
  addi $s7, $s7, 1            # ++i
  slt $t9, $s7, $t0           # $t9 = $s7(i) < $t0(p-1)
  beq $t9, $0, ISP_exit2      # branch exit_a2 if $t9 is false
  j ISP_loop

##########################################################
### (4) 			return 0;
##########################################################

ISP_exit1:
# return 0
  li $v0, 0                   # return 0;
  j ISP_return

##########################################################
### (5) 	return 1;
##########################################################

ISP_exit2:
  li $v0, 1                   # return 1;

ISP_return:

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

# print test notification
  la $a0, PROMPT_ISP
  li $v0, 4
	syscall

##########################################################
### Tests is_small_prime(7), expects 1
##########################################################

# first call ($a0=7)
  li $a0, 7
  jal is_small_prime

  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

##########################################################
### Tests is_small_prime(81), expects 0
##########################################################

# second call ($a0=81)
  li $a0, 81
  jal is_small_prime

  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

##########################################################
### Tests is_small_prime(127), expects 1
##########################################################

# third call ($a0=127)
  li $a0, 127
  jal is_small_prime

  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

##########################################################
### Exit the program
##########################################################

# exit
  li $v0, 10                  # load exit syscall code
  syscall                     # exit
