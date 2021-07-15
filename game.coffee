crypto = require('crypto');
Const = require('./const')
Piece = require('./piece')
Board = require('./board')

startTime = new Date().getTime()

class Node
    _counter = 0
    _duplication = []

    # 同じ駒が複数使用されていることもあるので座標も含めてソート
    _sortCoordinate = (a, b) ->
        kinds = ["Ou", "Hi", "Ka", "Ki", "Gi", "Ke", "Ky", "Fu"]
        return kinds.indexOf(a["kind"]) - kinds.indexOf(b["kind"]) || a["posi0"] - b["posi0"] || a["posi1"] - b["posi1"]

    # 局面を比較するためHashを生成
    @make_hash = (board) ->
        rec = []
        for koma in board.pieces
            buf = {}
            buf["kind"] = koma.kind()
            buf["turn"] = koma.turn
            buf["status"] = koma.status
            buf["posi0"] = koma.posi[0]
            buf["posi1"] = koma.posi[1]
            rec.push(buf)
        rec.sort _sortCoordinate
        return crypto.createHash('md5').update(JSON.stringify(rec)).digest("hex")

    # 重複局面をチェックするために局面のHash値を追加
    @set_dup = (hash) ->
        _duplication.push(hash)

    # 出現済みの局面ならtrue、新規局面ならfalseを返す
    @check_dup = (hash) ->
        check = (v for v in _duplication when v == hash)
        if check.length > 0
            return true
        else
            return false

    # Boardオブジェクトとその子局面を格納するための配列を用意
    constructor: (v) ->
        @value = v
        @child = []

    # 答えの局面を探して見つけたら手数と局面を表示
    search: (target) ->
        return null unless target?
        return @ if Node.make_hash(@value) == Node.make_hash(target)
        ret = false
        for v in @child
            # 答えの局面を見つけた
            if Node.make_hash(v.value) == Node.make_hash(target)
                ret = true
                _counter += 1
                console.log("#{_counter}:")
                v.value.display()
            else
                ret = v.search(target)
                # 答えを見つけた後は、その過程の局面と手数を遡って表示
                if ret
                    _counter += 1
                    console.log("#{_counter}:")
                    v.value.display()
            break if ret
        return ret

    # 子局面を辿りながら多分木データを追加していく
    add: (target, obj) ->
        ret = null
        for v, i in @child
            # 親となる局面を見つけたらその子局面としてNodeオブジェクトを追加
            if Node.make_hash(v.value) == Node.make_hash(target)
                ret = v.child.push(obj)
            # 見つからなければさらに子局面を辿る
            else
                ret = v.add(target, obj)
            break if ret?
        return ret

    deepest: ->
        ret = null
        has_child = false
        for v, i in @child
            if v.child.length > 0
                has_child = true
                break
        if has_child == false
            ret = true
            _counter += 1
            console.log("#{_counter}")
            v.value.display()
        else
            ret = v.deepest()
            if ret
                _counter += 1
                console.log("#{_counter}:")
                v.value.display()
        return ret

    childCount: ->
        ret = null
        console.log("@.child.length = #{@.child.length}")
        for v, i in @child
            v.childCount()
        return ret

    recurCount: (cnt) ->
        # console.log("cnt = #{cnt}")
        if _counter < cnt
            _counter = cnt
        # @.value.display() if cnt == 25
        cnt += 1
        for v, i in @child
            v.recurCount(cnt)
        return _counter

bfs = (board) ->
    queue = []
    queue.push(board)
    seq = 0
    layer = 0
    hitFlg = false
    while queue.length > 0
        bd = queue.shift()
        layer += 1
        for koma in bd.pieces
            for v in eval("Piece." + koma.kind()).getD(koma.turn, koma.status)
                buf = [].concat(koma.posi)
                loop
                    break unless ((buf[0] + v.xd in [1..bd.cols]) && (buf[1] + v.yd in [1..bd.rows]))
                    buf[0] += v.xd; buf[1] += v.yd
                    dest = (o for o in bd.pieces when o.posi? && o.posi[0] == buf[0] && o.posi[1] == buf[1])
                    break if dest.length != 0 && dest[0].turn == koma.turn
                    if bd.check_move(koma, buf)
                        # 着手可能な手ならBoardオブジェクトをディープコピー（新たな局面を生成）
                        temp = bd.clone()
                        move_piece = (o for o in temp.pieces when o.posi? && o.posi[0] == koma.posi[0] && o.posi[1] == koma.posi[1])
                        temp.move_capture(move_piece[0], buf)
                        md5hash = Node.make_hash(temp)
                        if Node.make_hash(answer) == md5hash
                            console.log("--- Hit!!")
                            console.log("seq = #{seq}")
                            hitFlg = true
                            # temp.display()
                        # temp.display()

                        # 重複局面は多分木データに追加しない
                        if Node.check_dup(md5hash)
                            continue
                        else
                            Node.set_dup(md5hash)
                        seq += 1
                        if layer == 1
                            node.child.push(new Node(temp))
                        else
                            node.add(bd, new Node(temp))
                        return if hitFlg
                        queue.push(temp)
                        # console.log("seq = #{seq}")
                    break unless (dest.length == 0 && v.series)
b = new Board()

# # puzzle0
# b.pieces = []
# b.pieces.push(new Piece.Ou(Const.FIRST, Const.Status.OMOTE, [1,1]))
# b.pieces.push(new Piece.Hi(Const.FIRST, Const.Status.OMOTE, [3,2]))
# b.pieces.push(new Piece.Ka(Const.FIRST, Const.Status.OMOTE, [2,3]))
# b.pieces.push(new Piece.Ki(Const.FIRST, Const.Status.OMOTE, [3,3]))
# b.pieces.push(new Piece.Gi(Const.FIRST, Const.Status.OMOTE, [1,2]))
# b.pieces.push(new Piece.Ke(Const.FIRST, Const.Status.OMOTE, [2,2]))
# b.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [1,3]))
# b.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.URA, [3,1]))

# # answer0
# answer = new Board()
# answer.pieces.push(new Piece.Ou(Const.FIRST, Const.Status.OMOTE, [3,3]))
# answer.pieces.push(new Piece.Hi(Const.FIRST, Const.Status.OMOTE, [3,2]))
# answer.pieces.push(new Piece.Ka(Const.FIRST, Const.Status.OMOTE, [1,2]))
# answer.pieces.push(new Piece.Ki(Const.FIRST, Const.Status.OMOTE, [1,3]))
# answer.pieces.push(new Piece.Gi(Const.FIRST, Const.Status.OMOTE, [3,1]))
# answer.pieces.push(new Piece.Ke(Const.FIRST, Const.Status.OMOTE, [2,2]))
# answer.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [1,1]))
# answer.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.URA, [2,3]))

###
２一と、３一飛、３二角、２三銀、１二玉、１一と、２一玉、１二銀、２三角、３二玉、２一飛、３一玉、３二角、２三銀、１二と、１一飛、２一と、１二銀、２三角、３二玉、３一と、２一玉、３二と、３一玉、２一銀、１二角、２三金、３三と、３二銀、２一角、１二歩、１三金、２三銀、３二角、２一飛、１一歩、１二銀、２三角、３二玉、３一飛、２一玉、３二飛、３一玉、２一銀、１二角、２三と、３三飛、３二銀、２一玉、３一銀、３二玉、２一角、１二金、１三と、２三玉、３二飛、３三玉、２三と、１三金、１二角
60手

###

# puzzle1
# 2018/7/27
b.pieces = []
b.pieces.push(new Piece.Ka(Const.FIRST, Const.Status.OMOTE, [3,1]))
b.pieces.push(new Piece.Gi(Const.FIRST, Const.Status.OMOTE, [2,2]))
b.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [3,3]))
b.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [2,1]))
b.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [1,3]))

# answer1
answer = new Board()
answer.pieces.push(new Piece.Ka(Const.FIRST, Const.Status.OMOTE, [1,3]))
answer.pieces.push(new Piece.Gi(Const.FIRST, Const.Status.OMOTE, [2,2]))
answer.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [3,3]))
answer.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [2,1]))
answer.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [1,1]))

###
１一銀、１二歩、１三角、２二銀、１一歩
###

# # answer1-deepest
# answer = new Board()
# answer.pieces.push(new Piece.Ka(Const.FIRST, Const.Status.OMOTE, [3,3]))
# answer.pieces.push(new Piece.Gi(Const.FIRST, Const.Status.OMOTE, [2,3]))
# answer.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [3,1]))
# answer.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [2,1]))
# answer.pieces.push(new Piece.Fu(Const.FIRST, Const.Status.OMOTE, [1,1]))

node = new Node(b)
bfs(b)
node.search(answer)
b.display()

elapsed = new Date().getTime() - startTime
console.log "経過時間: #{elapsed}ミリ秒"

console.log("deepest = #{node.recurCount(0)}")
