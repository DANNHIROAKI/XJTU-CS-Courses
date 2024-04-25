#include<iostream>
using namespace std;

//deivde-and-conquer to solve 
//the chessboard problem

int num = 0;
int board[100][100] = {0};

void chessboard(int, int, int, int, int);
void print(int[100][100], int);

int main()
{
    int dr, dc, size;
    //position of the special square
    dr = 4;
    dc = 3;
    //size of the board
    size = 32;
    chessboard(0, 0, dr, dc, size);
    print(board, size);
    return 0;
}

void chessboard(int tr, int tc, int dr, int dc, int size)
{
    //tr:left-up position(row)
    //tc:left-up position(column)
    //dr:special square position(row)
    //dc:special square position(column)
    //size:chessboard size

    if(size==1)return;

    //number of Tboard
    int t = ++num;
    int s = size / 2;
    
    if(dr<tr+s&&dc<tc+s)
    {
        //special square is in the left-up area
        chessboard(tr, tc, dr, dc, s);
    }
    else
    {
        /*mark the right-down square*/
        board[tr + s - 1][tc + s - 1] = t;
        chessboard(tr, tc, tr + s - 1, tc + s - 1, s);
    }

        if(dr>=tr+s&&dc<tc+s)
    {
        //special square is in the left-down area
        chessboard(tr + s, tc, dr, dc, s);
    }
    else
    {
        /*mark the right-up square*/
        board[tr + s][tc + s - 1] = t;
        chessboard(tr + s, tc, tr + s, tc + s - 1, s);
    }

        if(dr<tr+s&&dc>=tc+s)
    {
        //special square is in the right-up area
        chessboard(tr, tc + s, dr, dc, s);
    }
    else
    {
        /*mark the left-down square*/
        board[tr + s - 1][tc + s] = t;
        chessboard(tr, tc + s, tr + s - 1, tc + s, s);
    }

        if(dr>=tr+s&&dc>=tc+s)
    {
        //special square is in the right-down area
        chessboard(tr + s, tc + s, dr, dc, s);
    }
    else
    {
        /*mark the right-down square*/
        board[tr + s][tc + s] = t;
        chessboard(tr + s, tc + s, tr + s, tc + s, s);
    }
}

void print(int board[100][100],int size)
{
    //print the figure
    cout << "****************" << endl;
    for (int i = 0; i < size;i++)
    {
        for (int j = 0; j < size;j++)
        {
            if(board[i][j]<10)
                cout << "  " << board[i][j] << " ";
            else if(board[i][j]<100)
                cout << " " << board[i][j] << " ";
                else
                cout << board[i][j] << " ";
        }
        cout << endl;
    }
    cout << "****************" << endl;
}