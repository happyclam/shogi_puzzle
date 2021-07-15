# shogi_puzzle
将棋パズル（結将棋）解答プログラム

[「BFSで将棋パズルを解く」](https://happyclam.github.io/software/2018-08-18/puzzle)
    
~~~JavaScript

# 問題の駒を配置
#  3 2 1
# |M|F| |1
# | |G| |2
# |F| |F|3

b.pieces = []
b.pieces.push(new Piece.Ka(Const.FIRST, Const.Status.OMOTE, [3,1]))
b.pieces.push(new Piece.Gi(Const.FIRST, Const.Status.OMOTE, [2,2]))
b.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [3,3]))
b.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [2,1]))
b.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [1,3]))

~~~

    
~~~JavaScript

#解答の駒を配置
#  3 2 1
# | |F|F|1
# | |G| |2
# |F| |M|3

answer = new Board()
answer.pieces.push(new Piece.Ka(Const.FIRST, Const.Status.OMOTE, [1,3]))
answer.pieces.push(new Piece.Gi(Const.FIRST, Const.Status.OMOTE, [2,2]))
answer.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [3,3]))
answer.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [2,1]))
answer.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [1,1]))

~~~

    
~~~JavaScript

#解答プログラム（game.coffee）実行
$ coffee game.coffee
--- Hit!!
seq = 43
1:

 3 2 1
| |F|F|1
| |G| |2
|F| |M|3

2:

 3 2 1
| |F| |1
| |G|F|2
|F| |M|3

3:

 3 2 1
| |F|G|1
| | |F|2
|F| |M|3

4:

 3 2 1
|M|F|G|1
| | |F|2
|F| | |3

5:

 3 2 1
|M|F|G|1
| | | |2
|F| |F|3


 3 2 1
|M|F| |1
| |G| |2
|F| |F|3

経過時間: 48ミリ秒
deepest = 5

~~~


