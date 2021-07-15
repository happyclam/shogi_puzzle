Const = require('./const')

class Course
    constructor: (series = false, xd = 0, yd = 0) ->
        @series = series
        @xd = xd
        @yd = yd

class Piece
    constructor: (@turn, @status, @posi = null) ->
        @posi = if @posi? then @posi.concat() else []
        @id = uniqueId.call @
        
    setTurn: (turn) ->
        if turn != @turn
            @turn = turn
            
    uniqueId = (length = 8) ->
        id = ""
        id += Math.random().toString(36).substr(2) while id.length < length
        return id.substr 0, length

class Ou extends Piece
    _direction = {}
    _direction[Const.Status.OMOTE] = {}
    _direction[Const.Status.URA] = {}
    _direction[Const.Status.MOTIGOMA] = {}
    _direction[Const.Status.OMOTE][Const.FIRST] = [new Course(false, 0, -1), new Course(false, -1, -1), new Course(false, -1, 0), new Course(false, -1, 1), new Course(false, 0, 1), new Course(false, 1, 1), new Course(false, 1, 0), new Course(false, 1, -1)]
    _direction[Const.Status.OMOTE][Const.SECOND] = [new Course(false, 0, 1), new Course(false, 1, 1), new Course(false, 1, 0), new Course(false, 1, -1), new Course(false, 0, -1), new Course(false, -1, -1), new Course(false, -1, 0), new Course(false, -1, 1)]
    _direction[Const.Status.URA][Const.FIRST] = []
    _direction[Const.Status.URA][Const.SECOND] = []
    _direction[Const.Status.MOTIGOMA][Const.FIRST] = []
    _direction[Const.Status.MOTIGOMA][Const.SECOND] = []
    @getD: (turn, status) ->
        return _direction[status][turn]

    constructor: (turn, status, posi) ->
        super(turn, status, posi)

    kind: ->
        @constructor.name

    omomi: ->
        switch @status
            when Const.Status.OMOTE then 9999
            when Const.Status.URA then 9999
            when Const.Status.MOTIGOMA then 9999
            else 0

    caption: ->
        switch @status
            when Const.Status.OMOTE
                if @turn == Const.FIRST then 'O' else 'o'
            when Const.Status.URA
                if @turn == Const.FIRST then 'O' else 'o'
            when Const.Status.MOTIGOMA
                if @turn == Const.FIRST then 'O' else 'o'

class Hi extends Piece
    _direction = {}
    _direction[Const.Status.OMOTE] = {}
    _direction[Const.Status.URA] = {}
    _direction[Const.Status.MOTIGOMA] = {}
    _direction[Const.Status.OMOTE][Const.FIRST] = [new Course(true, 0, -1), new Course(true, -1, 0), new Course(true, 0, 1), new Course(true, 1, 0)]
    _direction[Const.Status.OMOTE][Const.SECOND] = [new Course(true, 0, 1), new Course(true, 1, 0), new Course(true, 0, -1), new Course(true, -1, 0)]
    _direction[Const.Status.URA][Const.FIRST] = [new Course(true, 0, -1), new Course(false, -1, -1), new Course(true, -1, 0), new Course(false, -1, 1), new Course(true, 0, 1), new Course(false, 1, 1), new Course(true, 1, 0), new Course(false, 1, -1)]
    _direction[Const.Status.URA][Const.SECOND] = [new Course(true, 0, 1), new Course(false, 1, 1), new Course(true, 1, 0), new Course(false, 1, -1), new Course(true, 0, -1), new Course(false, -1, -1), new Course(true, -1, 0), new Course(false, -1, 1)]
    _direction[Const.Status.MOTIGOMA][Const.FIRST] = [new Course(true, 0, -1), new Course(true, -1, 0), new Course(true, 0, 1), new Course(true, 1, 0)]
    _direction[Const.Status.MOTIGOMA][Const.SECOND] = [new Course(true, 0, 1), new Course(true, 1, 0), new Course(true, 0, -1), new Course(true, -1, 0)]
    @getD: (turn, status) ->
        return _direction[status][turn]

    constructor: (turn, status, posi) ->
        super(turn, status, posi)

    kind: ->
        @constructor.name

    omomi: ->
        switch @status
            when Const.Status.OMOTE then 85
            when Const.Status.URA then 110
            when Const.Status.MOTIGOMA then 75
            else 0

    caption: ->
        switch @status
            when Const.Status.OMOTE
                if @turn == Const.FIRST then 'H' else 'h'
            when Const.Status.URA
                if @turn == Const.FIRST then 'R' else 'r'
            when Const.Status.MOTIGOMA
                if @turn == Const.FIRST then 'H' else 'h'

class Ka extends Piece
    _direction = {}
    _direction[Const.Status.OMOTE] = {}
    _direction[Const.Status.URA] = {}
    _direction[Const.Status.MOTIGOMA] = {}
    _direction[Const.Status.OMOTE][Const.FIRST] = [new Course(true, -1, -1), new Course(true, -1, 1), new Course(true, 1, 1), new Course(true, 1, -1)]
    _direction[Const.Status.OMOTE][Const.SECOND] = [new Course(true, 1, 1), new Course(true, 1, -1), new Course(true, -1, -1), new Course(true, -1, 1)]
    _direction[Const.Status.URA][Const.FIRST] = [new Course(false, 0, -1), new Course(true, -1, -1), new Course(false, -1, 0), new Course(true, -1, 1), new Course(false, 0, 1), new Course(true, 1, 1), new Course(false, 1, 0), new Course(true, 1, -1)]
    _direction[Const.Status.URA][Const.SECOND] = [new Course(false, 0, 1), new Course(true, 1, 1), new Course(false, 1, 0), new Course(true, 1, -1), new Course(false, 0, -1), new Course(true, -1, -1), new Course(false, -1, 0), new Course(true, -1, 1)]
    _direction[Const.Status.MOTIGOMA][Const.FIRST] = [new Course(true, -1, -1), new Course(true, -1, 1), new Course(true, 1, 1), new Course(true, 1, -1)]
    _direction[Const.Status.MOTIGOMA][Const.SECOND] = [new Course(true, 1, 1), new Course(true, 1, -1), new Course(true, -1, -1), new Course(true, -1, 1)]
    @getD: (turn, status) ->
        return _direction[status][turn]

    constructor: (turn, status, posi) ->
        super(turn, status, posi)

    kind: ->
        @constructor.name

    omomi: ->
        switch @status
            when Const.Status.OMOTE then 75
            when Const.Status.URA then 100
            when Const.Status.MOTIGOMA then 65
            else 0

    caption: ->
        switch @status
            when Const.Status.OMOTE
                if @turn == Const.FIRST then 'M' else 'm'
            when Const.Status.URA
                if @turn == Const.FIRST then 'U' else 'u'
            when Const.Status.MOTIGOMA
                if @turn == Const.FIRST then 'M' else 'm'

class Ki extends Piece
    _direction = {}
    _direction[Const.Status.OMOTE] = {}
    _direction[Const.Status.URA] = {}
    _direction[Const.Status.MOTIGOMA] = {}
    _direction[Const.Status.OMOTE][Const.FIRST] = [new Course(false, 0, -1), new Course(false, -1, -1), new Course(false, -1, 0), new Course(false, 0, 1), new Course(false, 1, 0), new Course(false, 1, -1)]
    _direction[Const.Status.OMOTE][Const.SECOND] = [new Course(false, 0, 1), new Course(false, 1, 1), new Course(false, 1, 0), new Course(false, 0, -1), new Course(false, -1, 0), new Course(false, -1, 1)]
    _direction[Const.Status.URA][Const.FIRST] = []
    _direction[Const.Status.URA][Const.SECOND] = []
    _direction[Const.Status.MOTIGOMA][Const.FIRST] = [new Course(false, 0, -1), new Course(false, -1, -1), new Course(false, -1, 0), new Course(false, 0, 1), new Course(false, 1, 0), new Course(false, 1, -1)]
    _direction[Const.Status.MOTIGOMA][Const.SECOND] = [new Course(false, 0, 1), new Course(false, 1, 1), new Course(false, 1, 0), new Course(false, 0, -1), new Course(false, -1, 0), new Course(false, -1, 1)]
    @getD: (turn, status) ->
        return _direction[status][turn]

    constructor: (turn, status, posi) ->
        super(turn, status, posi)

    kind: ->
        @constructor.name

    omomi: ->
        switch @status
            when Const.Status.OMOTE then 50
            when Const.Status.URA then 50
            when Const.Status.MOTIGOMA then 45
            else 0

    caption: ->
        switch @status
            when Const.Status.OMOTE
                if @turn == Const.FIRST then 'X' else 'x'
            when Const.Status.URA
                if @turn == Const.FIRST then 'X' else 'x'
            when Const.Status.MOTIGOMA
                if @turn == Const.FIRST then 'X' else 'x'

class Gi extends Piece
    _direction = {}
    _direction[Const.Status.OMOTE] = {}
    _direction[Const.Status.URA] = {}
    _direction[Const.Status.MOTIGOMA] = {}
    _direction[Const.Status.OMOTE][Const.FIRST] = [new Course(false, 0, -1), new Course(false, -1, -1), new Course(false, -1, 1), new Course(false, 1, 1), new Course(false, 1, -1)]
    _direction[Const.Status.OMOTE][Const.SECOND] = [new Course(false, 0, 1), new Course(false, 1, 1), new Course(false, 1, -1), new Course(false, -1, -1), new Course(false, -1, 1)]
    _direction[Const.Status.URA][Const.FIRST] = [new Course(false, 0, -1), new Course(false, -1, -1), new Course(false, -1, 0), new Course(false, 0, 1), new Course(false, 1, 0), new Course(false, 1, -1)]
    _direction[Const.Status.URA][Const.SECOND] = [new Course(false, 0, 1), new Course(false, 1, 1), new Course(false, 1, 0), new Course(false, 0, -1), new Course(false, -1, 0), new Course(false, -1, 1)]
    _direction[Const.Status.MOTIGOMA][Const.FIRST] = [new Course(false, 0, -1), new Course(false, -1, -1), new Course(false, -1, 1), new Course(false, 1, 1), new Course(false, 1, -1)]
    _direction[Const.Status.MOTIGOMA][Const.SECOND] = [new Course(false, 0, 1), new Course(false, 1, 1), new Course(false, 1, -1), new Course(false, -1, -1), new Course(false, -1, 1)]
    @getD: (turn, status) ->
        return _direction[status][turn]

    constructor: (turn, status, posi) ->
        super(turn, status, posi)

    kind: ->
        @constructor.name

    omomi: ->
        switch @status
            when Const.Status.OMOTE then 45
            when Const.Status.URA then 50
            when Const.Status.MOTIGOMA then 40
            else 0

    caption: ->
        switch @status
            when Const.Status.OMOTE
                if @turn == Const.FIRST then 'G' else 'g'
            when Const.Status.URA
                if @turn == Const.FIRST then 'N' else 'n'
            when Const.Status.MOTIGOMA
                if @turn == Const.FIRST then 'G' else 'g'

class Ke extends Piece
    _direction = {}
    _direction[Const.Status.OMOTE] = {}
    _direction[Const.Status.URA] = {}
    _direction[Const.Status.MOTIGOMA] = {}
    _direction[Const.Status.OMOTE][Const.FIRST] = [new Course(false, 1, -2), new Course(false, -1, -2)]
    _direction[Const.Status.OMOTE][Const.SECOND] = [new Course(false, -1, 2), new Course(false, 1, 2)]
    _direction[Const.Status.URA][Const.FIRST] = [new Course(false, 0, -1), new Course(false, -1, -1), new Course(false, -1, 0), new Course(false, 0, 1), new Course(false, 1, 0), new Course(false, 1, -1)]
    _direction[Const.Status.URA][Const.SECOND] = [new Course(false, 0, 1), new Course(false, 1, 1), new Course(false, 1, 0), new Course(false, 0, -1), new Course(false, -1, 0), new Course(false, -1, 1)]
    _direction[Const.Status.MOTIGOMA][Const.FIRST] = [new Course(false, 1, -2), new Course(false, -1, -2)]
    _direction[Const.Status.MOTIGOMA][Const.SECOND] = [new Course(false, -1, 2), new Course(false, 1, 2)]
    @getD: (turn, status) ->
        return _direction[status][turn]

    constructor: (turn, status, posi) ->
        super(turn, status, posi)

    kind: ->
        @constructor.name

    omomi: ->
        switch @status
            when Const.Status.OMOTE then 30
            when Const.Status.URA then 50
            when Const.Status.MOTIGOMA then 25
            else 0

    caption: ->
        switch @status
            when Const.Status.OMOTE
                if @turn == Const.FIRST then 'K' else 'k'
            when Const.Status.URA
                if @turn == Const.FIRST then 'E' else 'e'
            when Const.Status.MOTIGOMA
                if @turn == Const.FIRST then 'K' else 'k'

class Ky extends Piece
    _direction = {}
    _direction[Const.Status.OMOTE] = {}
    _direction[Const.Status.URA] = {}
    _direction[Const.Status.MOTIGOMA] = {}
    _direction[Const.Status.OMOTE][Const.FIRST] = [new Course(true, 0, -1)]
    _direction[Const.Status.OMOTE][Const.SECOND] = [new Course(true, 0, 1)]
    _direction[Const.Status.URA][Const.FIRST] = [new Course(false, 0, -1), new Course(false, -1, -1), new Course(false, -1, 0), new Course(false, 0, 1), new Course(false, 1, 0), new Course(false, 1, -1)]
    _direction[Const.Status.URA][Const.SECOND] = [new Course(false, 0, 1), new Course(false, 1, 1), new Course(false, 1, 0), new Course(false, 0, -1), new Course(false, -1, 0), new Course(false, -1, 1)]
    _direction[Const.Status.MOTIGOMA][Const.FIRST] = [new Course(true, 0, -1)]
    _direction[Const.Status.MOTIGOMA][Const.SECOND] = [new Course(true, 0, 1)]
    @getD: (turn, status) ->
        return _direction[status][turn]

    constructor: (turn, status, posi) ->
        super(turn, status, posi)

    kind: ->
        @constructor.name

    omomi: ->
        switch @status
            when Const.Status.OMOTE then 25
            when Const.Status.URA then 50
            when Const.Status.MOTIGOMA then 20
            else 0

    caption: ->
        switch @status
            when Const.Status.OMOTE
                if @turn == Const.FIRST then 'Y' else 'y'
            when Const.Status.URA
                if @turn == Const.FIRST then 'S' else 's'
            when Const.Status.MOTIGOMA
                if @turn == Const.FIRST then 'Y' else 'y'

class Fu extends Piece
    _direction = {}
    _direction[Const.Status.OMOTE] = {}
    _direction[Const.Status.URA] = {}
    _direction[Const.Status.MOTIGOMA] = {}
    _direction[Const.Status.OMOTE][Const.FIRST] = [new Course(false, 0, -1)]
    _direction[Const.Status.OMOTE][Const.SECOND] = [new Course(false, 0, 1)]
    _direction[Const.Status.URA][Const.FIRST] = [new Course(false, 0, -1), new Course(false, -1, -1), new Course(false, -1, 0), new Course(false, 0, 1), new Course(false, 1, 0), new Course(false, 1, -1)]
    _direction[Const.Status.URA][Const.SECOND] = [new Course(false, 0, 1), new Course(false, 1, 1), new Course(false, 1, 0), new Course(false, 0, -1), new Course(false, -1, 0), new Course(false, -1, 1)]
    _direction[Const.Status.MOTIGOMA][Const.FIRST] = [new Course(false, 0, -1)]
    _direction[Const.Status.MOTIGOMA][Const.SECOND] = [new Course(false, 0, 1)]
    @getD: (turn, status) ->
        return _direction[status][turn]

    constructor: (turn, status, posi) ->
        super(turn, status, posi)

    kind: ->
        @constructor.name

    omomi: ->
        switch @status
            when Const.Status.OMOTE then 10
            when Const.Status.URA then 50
            when Const.Status.MOTIGOMA then 7
            else 0

    caption: ->
        switch @status
            when Const.Status.OMOTE
                if @turn == Const.FIRST then 'F' else 'f'
            when Const.Status.URA
                if @turn == Const.FIRST then 'T' else 't'
            when Const.Status.MOTIGOMA
                if @turn == Const.FIRST then 'F' else 'f'

module.exports =
    Course: Course
    Piece: Piece
    Ou: Ou
    Hi: Hi
    Ka: Ka
    Ki: Ki
    Gi: Gi
    Ke: Ke
    Ky: Ky
    Fu: Fu
