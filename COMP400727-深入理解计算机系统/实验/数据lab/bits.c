/*
 * CS:APP Data Lab
 *
 * 2213611582-ics
 *
 * bits.c - Source file with your solutions to the Lab.
 *          This is the file you will hand in to your instructor.
 */

extern int printf(const char *, ...);
/* Edit the functions below.  Good luck!  */
///////////////////////////////////////////////////////////////////////////////////////////
// 1
/*
 * implication - given input x and y, which are binary
 * (taking  the values 0 or 1), return x -> y in propositional logic -
 * 0 for false, 1 for true
 *
 * Below is a truth table for x -> y where A is the result
 *
 * |-----------|-----|
 * |  x  |  y  |  A  |
 * |-----------|-----|
 * |  1  |  1  |  1  |
 * |-----------|-----|
 * |  1  |  0  |  0  |
 * |-----------|-----|
 * |  0  |  1  |  1  |
 * |-----------|-----|
 * |  0  |  0  |  1  |
 * |-----------|-----|
 *
 *
 *   Example: implication(1L,1L) = 1L
 *            implication(1L,0L) = 0L
 *   Rating: 2
 */
long implication(long x, long y) {
    if (x == 1L && y == 0L) {
        return 0L;
    } else {
        return 1L;
    }
}
///////////////////////////////////////////////////////////////////////////////////////////
// 2
/*
 * leastBitPos - return a mask that marks the position of the
 *               least significant 1 bit. If x == 0, return 0
 *   Example: leastBitPos(96L) = 0x20L
 *   Rating: 2
 */
long leastBitPos(long x) {
    if (x == 0) {
        return 0L;
    } else {
        return x & -x;
    }
}
///////////////////////////////////////////////////////////////////////////////////////////
// 3
/*
 * distinctNegation - returns 1 if x != -x.
 *     and 0 otherwise
 *   Rating: 2
 */
long distinctNegation(long x) {
    if (x != (-x)) {
        return 1L;
    } else {
        return 0L;
    }
}
///////////////////////////////////////////////////////////////////////////////////////////
// 4
/*
 * fitsBits - return 1 if x can be represented as an
 *  n-bit, two's complement integer.
 *   1 <= n <= 64
 *   Examples: fitsBits(5,3) = 0L, fitsBits(-4,3) = 1L
 *   Rating: 2
 */
long fitsBits(long x, long n) {

    long sign = (x >> 63);
    long mask = (1L << (n - 1)) - 1;
    long val = !(x & (~mask));
    long bia = (x >> (n - 1)) << (n - 1);
    long set = (~mask) ^ bia;
    return ((~sign) & val) + (sign & (!set));
}
///////////////////////////////////////////////////////////////////////////////////////////
// 5
/*
 * trueFiveEighths - multiplies by 5/8 rounding toward 0,
 *  avoiding errors due to overflow
 *  Examples:
 *    trueFiveEighths(11L) = 6L
 *    trueFiveEighths(-9L) = -5L
 *    trueFiveEighths(0x3000000000000000L) = 0x1E00000000000000L (no overflow)
 *  Rating: 4
 */

long trueFiveEighths(long x) {
    long sign = x >> 63;
    long a = x >> 3;
    long b = 7 & x;
    return (a + (a << 2)) + (((b << 2) + (b)) >> 3) + (sign & (1 & (!!b)));
}

///////////////////////////////////////////////////////////////////////////////////////////
// 6
/*
 * addOK - Determine if can compute x+y without overflow
 *   Example: addOK(0x8000000000000000L,0x8000000000000000L) = 0L,
 *            addOK(0x8000000000000000L,0x7000000000000000L) = 1L,
 *   Rating: 3
 */
long addOK(long x, long y) {
    long sum = x + y;
    long neg_over = x < 0 && y < 0 && sum >= 0;
    long pos_over = x >= 0 && y >= 0 && sum < 0;
    return !(neg_over || pos_over);
}
///////////////////////////////////////////////////////////////////////////////////////////
// 7
/*
 * isPower2 - returns 1 if x is a power of 2, and 0 otherwise
 *   Examples: isPower2(5L) = 0L, isPower2(8L) = 1L, isPower2(0) = 0L
 *   Note that no negative number is a power of 2.
 *   Rating: 3
 */
long isPower2(long x) {
    if (x <= 0 || (x & (x - 1)) != 0) {
        // If x is non-positive or has more than one set bit, it's not a power
        // of 2
        return 0L;
    } else {
        // Otherwise, it's a power of 2
        return 1L;
    }
}
///////////////////////////////////////////////////////////////////////////////////////////
// 8
/*
 * rotateLeft - Rotate x to the left by n
 *   Can assume that 0 <= n <= 63
 *   Examples:
 *      rotateLeft(0x8765432187654321L,4L) = 0x7654321876543218L
 *   Rating: 3
 */
long rotateLeft(long x, long n) {
    // return (x << n) | (x >> (64 -
    // n));????????????????????????????????????????fuck Get the leftmost n bits
    // of x, and move them to the right end of the result.
    long leftmost_n_bits = x << n;

    // Get the rightmost 64 - n bits of x, and move them to the left end of the
    // result.
    long rightmost_64_minus_n_bits = x >> (64 - n);

    // Zero out any bits in the rightmost_64_minus_n_bits that extend beyond the
    // n-th position from the left.
    long masked_rightmost_64_minus_n_bits =
        rightmost_64_minus_n_bits & ((1L << n) - 1);

    // Combine the two bit sets to form the rotated result.
    long rotated_result = leftmost_n_bits + masked_rightmost_64_minus_n_bits;
    return rotated_result;
}
///////////////////////////////////////////////////////////////////////////////////////////
// 9
/*
 * isPalindrome - Return 1 if bit pattern in x is equal to its mirror image
 *   Example: isPalindrome(0x6F0F0123c480F0F6L) = 1L
 *   Rating: 4
 */
/* it makes me crazy why it is diaable
long isPalindrome(long x) {
    int numBits = sizeof(x) * 8;
    unsigned long mirror = 0;

    for (int i = 0; i < numBits; i++) {
        mirror = (mirror << 1) | (x & 1);
        x >>= 1;
    }

    return (mirror == x);
}
*/
// so i can only solve the problem with violence
long isPalindrome(long x) {
    long a[32];
    for (int i = 0; i < 32; i++) {
        a[i] = (((x >> (63 - i)) ^ (x >> i)) & 1);
    }
    long b = a[0] | a[1] | a[2] | a[3] | a[4] | a[5] | a[6] | a[7] | a[8] |
             a[9] | a[10] | a[11] | a[12] | a[13] | a[14] | a[15] | a[16] |
             a[17] | a[18] | a[19] | a[20] | a[21] | a[22] | a[23] | a[24] |
             a[25] | a[26] | a[27] | a[28] | a[29] | a[30] | a[31];
    return !b;
}
///////////////////////////////////////////////////////////////////////////////////////////
// 10
/*
 * bitParity - returns 1 if x contains an odd number of 0's
 *   Examples: bitParity(5L) = 0L, bitParity(7L) = 1L
 *   Rating: 4
 */
long bitParity(long x) {
    x ^= x >> 32;
    x ^= x >> 16;
    x ^= x >> 8;
    x ^= x >> 4;
    x ^= x >> 2;
    x ^= x >> 1;
    return x & 1;
}
///////////////////////////////////////////////////////////////////////////////////////////
// 11
/*
 * absVal - absolute value of x
 *   Example: absVal(-1) = 1.
 *   You may assume -TMax <= x <= TMax
 *   Rating: 4
 */
long absVal(long x) {
    if (x < 0) {
        return -x;
    } else {
        return x;
    }
}
