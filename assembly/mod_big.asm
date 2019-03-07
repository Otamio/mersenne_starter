# mod_big.asm
# Bigint mod_big(Bigint a, Bigint b) {
# 	Bigint original_b = b;
# 	while (compare_big(a, b) == 1)
# 		shift_right(&b);
# 	shift_left(&b);
# 	while (compare_big(b,original_b) != -1)
# 	{
# 		while (compare_big(a,b) != -1)
# 			a = sub_big(a,b);
# 		shift_left(&b);
# 	}
# 	return a;
# }
  .data
test_i:   .asciiz "Modulus Tests"
newline:  .asciiz "\n"
.align 2
bigint1:  .space  1404
.align 2
bigint2:  .space  1404
.align 2
bigint3:  .space  1404
.align 2
bigint4:  .space  1404

  .text
