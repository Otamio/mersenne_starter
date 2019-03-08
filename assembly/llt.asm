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
test_h:   .asciiz "LLT Tests"
newline:  .asciiz "\n"
.align 2
bigint1:  .space  1404
.align 2
bigint2:  .space  1404
.align 2
bigint3:  .space  1404
.align 2
bigint10:  .space  1404
.align 2
bigint11:  .space  1404
.align 2
bigint12:  .space  1404

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

# read parameters
  move $s0, $a0               # $s0 is p

# Initialize 0, 1, 2
# Initialize 0
  
