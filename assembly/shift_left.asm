# shift_left.asm
# void shift_left(Bigint *a) {
# 	// Copy stuff
# 	for (int i=0; i<a->n-1; ++i)
# 		a->digits[i] = a->digits[i+1];
# 	// Set highest digit to 0
# 	a->digits[a->n-1] = 0;
# 	// Set to new smaller size
# 	--a->n;
# 	// Trim any leading zeros
# 	compress(a);
# }
  .data
test_e:  .asciiz "Shift Left Test"
newline: .asciiz "\n"
.align 2
bigint1:  .space  1404

  .text
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



# test driver
main:
# print test notification
  la $a0, test_e
  li $v0, 4
  syscall

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

# init bigint
  la $a0, bigint1            # $a0 is the starting address of bigint1
  jal init_bigint

# load bigint
  li $t1, 4
  sw $t1, 0($a0)           # Bigint size is 4

  li $t1, 7
  sw $t1, 16($a0)          # first digit is 7 (no need to change since other bits are already 0)

# call shift_left 2 times
  jal shift_left
  jal shift_left

# call print_big
  jal print_big

# exit (from main)
  li $v0, 10                 # load exit syscall code
  syscall                    # exit
