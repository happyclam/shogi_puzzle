Const = require('./const')
Piece = require('./piece')

class Board
    @promotion_line = [1, 3]
    constructor: ->
        @rows = Const.COLS
        @cols = Const.ROWS
        # @pieces = ((null for c in [1..Const.COLS]) for r in [1..Const.ROWS])
        @pieces = []
        @kiki = {}

        # @kiki[Const.FIRST] = []
        # @kiki[Const.SECOND] = []

    set_standard: ->
        @pieces = []
        @pieces.push(new Piece.Ou(Const.FIRST, Const.Status.OMOTE, [3, 3]))
        @pieces.push(new Piece.Gi(Const.FIRST, Const.Status.MOTIGOMA))
        @pieces.push(new Piece.Fu(Const.FIRST, Const.Status.MOTIGOMA))
        @pieces.push(new Piece.Ou(Const.SECOND, Const.Status.OMOTE, [1, 1]))
        @pieces.push(new Piece.Gi(Const.SECOND, Const.Status.MOTIGOMA))
        @pieces.push(new Piece.Fu(Const.SECOND, Const.Status.MOTIGOMA))
        return

    clone: ->
        temp = new @.constructor()
        for koma in @pieces
            temp.pieces.push(eval("new Piece." + koma.kind() + "(" + koma.turn + "," + koma.status + ",[" + koma.posi.toString() + "])"))            
        return temp
        
    add: (piece) ->
        @pieces.push(piece)
        return

    gameover: ->
        kings = (v for v in @pieces when v.kind() == 'Ou' && v.turn == Const.FIRST)
        switch kings.length
            when 2
                return Const.FIRST
            when 0
                return Const.SECOND
            else
                return false

    display: ->
        # console.log(@pieces)
        # console.log(@motigoma)
        for v,i in @pieces when v.turn == Const.SECOND && v.status == Const.Status.MOTIGOMA
            process.stdout.write(v.caption()) if v?
        process.stdout.write("\n")

        for col in [@cols..1]
            process.stdout.write(" " + col.toString())
        process.stdout.write("\n")

        for row in [1..@rows]
            for col in [@cols..1] by -1
                # koma = (v for v in @pieces when v.posi? && v.posi.toString() == [col, row].toString())
                koma = (v for v in @pieces when v.posi? && v.posi[0] == col && v.posi[1] == row)
                process.stdout.write("|" + if koma.length != 0 then koma[0].caption() else " ")
            process.stdout.write("|" + row.toString() + "\n")

        for v,i in @pieces when v.turn == Const.FIRST && v.status == Const.Status.MOTIGOMA
            process.stdout.write(v.caption()) if v?
        process.stdout.write("\n")
        return

    make_kiki: (turn, exclude = null) ->
        @kiki[turn] = []
        selected = (v for v in @pieces when v.turn == turn && v.status != Const.Status.MOTIGOMA && v.kind() != exclude)
        for col in [1..@cols]
            for row in [1..@rows]
                for v in selected
                    if check_kiki.call @, v, [row, col]
                        @kiki[turn].push([row, col])
                        break
        return

    check_move: (piece, d_posi) ->
        # console.log("check_move")
        force_promo = false
        # dest = null
        # dest = (v for v in @pieces when v.posi? && v.posi.toString() == d_posi.toString())
        dest = (v for v in @pieces when v.posi? && v.posi[0] == d_posi[0] && v.posi[1] == d_posi[1])
        if piece.status == Const.Status.MOTIGOMA
            # 駒が存在しているところに駒を打とうとした
            console.log("--- Parameter Error in Board.check_move ---") if dest.length != 0
            if dest.length == 0 && check_potential.call @, piece, d_posi
                # 二歩チェック
                if (piece.kind() == 'Fu') && (check_nifu.call @, piece, d_posi)
                    # console.log("check0")
                    return false
                else
                    # console.log("check-1")
                    return true
            else
                # console.log("check00")
                return false
        else
            unless check_potential.call @, piece, d_posi
                if @check_promotion(piece, d_posi)
                    force_promo = false
                else
                    # console.log("check00-1")
                    return false
                    # console.log("--- Error in Board.check_move ---")

        for v in eval("Piece." + piece.kind()).getD(piece.turn, piece.status)
            buf = [].concat(piece.posi)
            buf[0] += v.xd; buf[1] += v.yd
            # if (buf.toString() == d_posi.toString())
            if (buf[0] == d_posi[0] && buf[1] == d_posi[1])
                if dest.length != 0
                    if (piece.turn != dest[0].turn)
                        piece.status = Const.Status.URA if force_promo
                        # console.log("check1")
                        return true
                else
                    piece.status = Const.Status.URA if force_promo
                    # console.log("check2")
                    return true
            if v.series
                while (buf[0] in [1..@cols]) && (buf[1] in [1..@rows])
                    # if (buf.toString() == d_posi.toString())
                    if (buf[0] == d_posi[0] && buf[1] == d_posi[1])
                        if dest.length == 0
                            piece.status = Const.Status.URA if force_promo
                            # console.log("check3")
                            return true
                        else
                            if (piece.turn != dest[0].turn)
                                piece.status = Const.Status.URA if force_promo
                                # console.log("check4")
                                return true
                            else
                                break
                    else
                        # break if (o for o in @pieces when o.posi? && o.posi.toString() == buf.toString())[0]?
                        break if (o for o in @pieces when o.posi? && o.posi[0] == buf[0] && o.posi[1] == buf[1])[0]?
                    buf[0] += v.xd; buf[1] += v.yd
        # console.log("check5")
        return false

    # 成れるかどうか判定
    check_promotion: (piece, d_posi) ->
        # posi = v for v in @pieces when (k ==
        return false unless piece.status == Const.Status.OMOTE
        return false if piece.kind() in ['Ou', 'Ki']
        switch piece.turn
            when Const.FIRST
                return true if (piece.posi[1] <= Board.promotion_line[0] || d_posi[1] <= Board.promotion_line[0])
            when Const.SECOND
                return true if (piece.posi[1] >= Board.promotion_line[1] || d_posi[1] >= Board.promotion_line[1])
        return false

    move_capture: (piece, d_posi) ->
        # dest = (v for v in @pieces when v.posi? && v.posi.toString() == d_posi.toString())
        dest = (v for v in @pieces when v.posi? && v.posi[0] == d_posi[0] && v.posi[1] == d_posi[1])
        if dest.length != 0
            dest[0].status = Const.Status.MOTIGOMA
            dest[0].setTurn(piece.turn)
            dest[0].posi = []
        else
            if piece.status == Const.Status.MOTIGOMA
                piece.status = Const.Status.OMOTE
        s_posi = [].concat(piece.posi)
        piece.posi = [].concat(d_posi)
        return s_posi

    check_utifudume: (piece, d_posi) ->
        # console.log("check_utifudume")
        oppo = if piece.turn == Const.FIRST then Const.SECOND else Const.FIRST
        oppo_king = (v for v in @pieces when v.turn == oppo && v.kind() == 'Ou')[0]
        # buf = [].concat(d_posi)
        # buf[0] += eval("Piece."+piece.kind()).getD(piece.turn, piece.status)[0].xd
        # buf[1] += eval("Piece."+piece.kind()).getD(piece.turn, piece.status)[0].yd
        #1,打ち歩による王手
        # check = piece.status == Const.Status.MOTIGOMA && piece.kind() == 'Fu' && oppo_king.posi[0] == buf[0] && oppo_king.posi[1] == buf[1]
        # console.log("check1")
        # return false unless check

        #2,打ち歩を玉以外の味方の駒で取ることが出来ない
        @make_kiki(oppo, 'Ou')
        # if (d_posi.toString() in @kiki[oppo].map (o) -> o.toString())
        if (o for o in @kiki[oppo] when o[0] == d_posi[0] && o[1] == d_posi[1])[0]?
            # console.log("check2")
            return false

        #3,玉が逃げることも出来ないし、打たれた歩に相手の駒の利きがある（玉で取ることも出来ない）
        @make_kiki(piece.turn)
        org = [].concat(oppo_king.posi)
        for v in Piece.Ou.getD(oppo_king.turn, oppo_king.status)
            dest = [org[0] + v.xd, org[1] + v.yd]
            continue unless (dest[0] in [1..@cols] && dest[1] in [1..@rows])
            # if (dest.toString() in @kiki[piece.turn].map (o) -> o.toString())
            if (o for o in @kiki[piece.turn] when o[0] == dest[0] && o[1] == dest[1])[0]?
                continue
            else
                unless (w for w in @pieces when w.posi? && w.posi[0] == dest[0] && w.posi[1] == dest[1])[0]?
                    return false
                # if @check_move(oppo_king, dest)
                #     # console.log("check3")
                #     return false
        # console.log("check4")
        return true

    check_nifu = (piece, d_posi) ->
        return (v for v in @pieces when v.posi? && v.posi[0] == d_posi[0] && v.kind() == 'Fu' && v.status == Const.Status.OMOTE && v.turn == piece.turn)[0]?

    # 打った後、指した後に移動可能な場所が無い場合falseを返す
    check_potential = (piece, d_posi) ->
        for v in eval("Piece." + piece.kind()).getD(piece.turn, piece.status)
            if ((d_posi[0] + v.xd) > 0) && ((d_posi[1] + v.yd) > 0) && ((d_posi[0] + v.xd) <= @cols) && ((d_posi[1] + v.yd) <= @rows)
                return true
        return false

    check_kiki = (piece, d_posi) ->
        for v in eval("Piece." + piece.kind()).getD(piece.turn, piece.status)
            buf = [].concat(piece.posi)
            loop
                buf[0] += v.xd; buf[1] += v.yd
                return true if buf[0] == d_posi[0] && buf[1] == d_posi[1]
                # temp = (o for o in @pieces when o.posi? && o.posi[0] == buf[0] && o.posi[1] == buf[1])[0]
                # break if temp?
                # break if (buf.toString() in (o for o in @pieces when o.posi?).map (it) -> it.posi.toString())
                break if (o for o in @pieces when o.posi? && o.posi[0] == buf[0] && o.posi[1] == buf[1])[0]?
                break unless (v.series && buf[0] in [1..@cols] && buf[1] in [1..@rows])
        return false

module.exports = Board
