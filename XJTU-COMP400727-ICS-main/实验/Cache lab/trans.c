
#include <stdio.h>
#include "cachelab.h"
int is_transpose(int M, int N, int A[N][M], int B[M][N]);
void transpose_32x32(int M, int N, int A[N][M], int B[M][N]);
void transpose_64x64(int M, int N, int A[N][M], int B[M][N]);
void transpose_61x67(int M, int N, int A[N][M], int B[M][N]);


char transpose_submit_desc[] = "Transpose submission";
void transpose_submit(int M, int N, int A[N][M], int B[M][N])
{
    int case_id = M * 1000 + N; 
        switch (case_id) {
    case 32032:
        transpose_32x32(M, N, A, B);
        break;
    case 64064:
        transpose_64x64(M, N, A, B);
        break;
    case 61067:
        transpose_61x67(M, N, A, B);
        break;
    default:
        break;
    }
}



void transpose_32x32(int M, int N, int A[N][M], int B[M][N])
{
    int i, j, tmp;

    for (i = 0; i < N; i += 8) {
        for (j = 0; j < M; j += 8) {
            for (int k = i; k < i + 8 && k < N; k++) {
                for (int l = j; l < j + 8 && l < M; l++) {
                    if (k != l) {
                        B[l][k] = A[k][l];
                    }
                    else {
                        tmp = A[k][l];
                    }
                }
                if (i == j) {
                    B[k][k] = tmp;
                }
            }
        }
    }
}

void transpose_64x64(int M, int N, int A[N][M], int B[M][N]) {
      int a[8];
    for (int i = 0; i < 64; i += 8)
    {
        for (int j = 0; j < 64; j += 8)
        {
            for (int k = i; k < i + 4; k++)
            {
               for(int m1=0;m1<=7;m1++)
               {
                a[m1]=A[k][j+m1];
               }
               for(int m2=0;m2<=3;m2++)
               {
                B[j+m2][k]=a[m2];
               }
               for(int m3=4;m3<=7;m3++)
               {
                B[j+m3-4][k+4]=a[m3];
               }
            }
            for (int k = j; k < j + 4; k++)
            {
               for(int n1=4;n1<=7;n1++)
               {
                a[n1-4]=B[k][i+n1];
               }
               for(int n2=4;n2<=7;n2++)
               {
                a[n2]=A[i+n2][k];
               }
               for(int n3=4;n3<=7;n3++)
               {
                B[k][i+n3]=a[n3];
               }
               for(int n4=0;n4<=3;n4++)
               {
                B[k+4][i+n4]=a[n4];
               }
            }
            for (int k = i + 4; k < i + 8; k++)
            {
               for(int x1=4;x1<=7;x1++)
               {
                a[x1]=A[k][j+x1];
               }
               for(int x2=4;x2<=7;x2++)
               {
                B[j+x2][k]=a[x2];
               }
            }
        }
    }
}


void transpose_61x67(int M, int N, int A[N][M], int B[M][N]) {
    const int BLOCK_SIZE = 16;
    for (int row = 0; row < N; row += BLOCK_SIZE) {
        for (int col = 0; col < M; col += BLOCK_SIZE) {
            for (int i = row; i < row + BLOCK_SIZE && i < N; i++) {
                int j;
                for (j = col; j < col + BLOCK_SIZE - 1 && j + 1 < M; j += 2) {
                    B[j][i] = A[i][j];
                    B[j + 1][i] = A[i][j + 1];
                }
                if (j < M) {
                    B[j][i] = A[i][j];
                }
            }
        }
    }
}


char trans_desc[] = "Simple row-wise scan transpose";
void trans(int M, int N, int A[N][M], int B[M][N])
{
    int i, tmp;
    int total_elements = M * N;

    for (i = 0; i < total_elements; i++)
    {
        int row = i / M;
        int col = i % M;

        tmp = A[row][col];
        B[col][row] = tmp;
    }
}



void registerFunctions()
{
    registerTransFunction(transpose_submit, transpose_submit_desc);
    registerTransFunction(trans, trans_desc);
}



int is_transpose(int M, int N, int A[N][M], int B[M][N])
{
    int index;

    for (index = 0; index < M * N; index++)
    {
        int i = index / M;
        int j = index % M;

        if (A[i][j] != B[j][i])
        {
            return 0;
        }
    }
    return 1;
}
