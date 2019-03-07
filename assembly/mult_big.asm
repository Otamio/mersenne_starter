# shift_left.asm
# Bigint mult_big(Bigint a, Bigint b) {
# 	Bigint c;
# 	c.n = a.n + b.n;
# 	for (int i=0; i < c.n; ++i)
# 		c.digits[i] = 0;
# 	for (int i=0; i < b.n; ++i) {
# 		int carry = 0;
# 		int j;
#
# 		for (j=i; j < a.n+i; ++j) {
# 			int val = c.digits[j] + (b.digits[i] * a.digits[j-i]) + carry;
# 			carry       = val / 10;
# 			c.digits[j] = val % 10;
# 		}
#
# 		if (carry > 0) {
# 			int val = c.digits[j] + carry;
# 			carry       = val / 10;
# 			c.digits[j] = val % 10;
# 		}
# 	}
# 	compress(&c);
# 	return c;
# }

  .data
test_g:   .asciiz "Multiplication Tests"
newline:  .asciiz "\n"
.align 2
bigint1:  .space  1404
.align 2
bigint2:  .space  1404
.align 2
bigint3:  .space  1404

  .text
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

  add $t8, $t8, $t3          # $t8 = b.digits[i] * a.digits[j-i] + c.digits[j] + carry



# val div (mod) 10
  li $t5, 10                  # $t5 = 10
  div $t8, $t5
  mflo $t3                    # $t3 = val / 10
  mfhi $t5                    # $t5 = val % 10
  sw $t5, 0($t4)              # c.digits[j] = val % 10

# increment j and go to next iteration
  addi $s6, $s6, 1            # $s6 += 1
  j MUL_loop_in

MUL_iend:
  ble $t3, $0, MUL_iloop_end  # branch if $t3 (carry) <= 0

  add $t8, $t5, $t3           # (optimized) val = c.digits[j] + carry

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
  la $a0, bigint3
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



# test driver
main:
# print test notification
  la $a0, test_g
  li $v0, 4
	syscall

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

# test case 1 (3 and 7)

# init bigint1
  la $a0, bigint1            # $a0 is the starting address of bigint1
  jal init_bigint            # initialize bigint 1

# load bigint1
  li $t1, 1
  sw $t1, 0($a0)            # Bigint size is 1

  li $t1, 3
  sw $t1, 4($a0)            # the digit is 3

# init bigint 2
  la $a0, bigint2           # $a0 is the starting address of bigint2
  jal init_bigint           # initialize bigint2

# load bigint2
  li $t1, 1
  sw $t1, 0($a0)            # Bigint size is 1

  li $t1, 7
  sw $t1, 8($a0)            # the digit is 7

# call mult_big
  la $a0, bigint1
  la $a1, bigint2
  la $a2, bigint3
  jal mult_big

# print output
  move $a0, $v0
  jal print_big

# exit (from main)
  li $v0, 10                 # load exit syscall code
  syscall                    # exit