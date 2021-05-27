-- Tic Tac Toe
-- Autor: Gustavo Antonio Lutz de Matos - gustavo.almatos@gmail.com
-- Jogo desenvolvido acompanhando o canal Glider (https://www.youtube.com/channel/UCBFCipnenbWX-EhWn05r6aA)

function criar_tabuleiro(_) return {{_, _, _}, {_, _, _}, {_, _, _}} end

function pula_linha(linhas) for __ = 0, linhas do print() end end

function abertura_jogo()
    pula_linha(2)
    print("\t=-=-=-=-=-=-=-=-=-=-=-=")
    print("\t=     TIC-TAC-TOE     =")
    print("\t=-=-=-=-=-=-=-=-=-=-=-=")
end

function validar_SO()
    home = os.getenv("HOME")
    if home == nil then return "|", "--", " " end
    return "↓", "→", "·"
end

function player_names()
    players = {}
    for i = 1, 2 do
        msg = "Digite o nome do jogador número %s: "
        io.write(msg:format(i))
        table.insert(players, io.read())
    end
    return players
end

function imprimir_tabuleiro(T, SB, SD)
    abertura_jogo()
    pula_linha(2)
    print(string.format("\t\tA B C\n\t\t%s %s %s", SB, SB, SB))
    for _ = 1, 3 do
        io.write(string.format("\t    %s %s ", _, SD))
        print(table.concat(T[_], " "))
    end
    pula_linha(2)
end

function ler_jogada(JOGADORES, X)
    validar_jogada = function(jogada)
        coluna = string.byte(jogada:upper()) - 64
        linha = tonumber(jogada:sub(2, 2))
        if coluna >= 1 and coluna <= 3 and linha >= 1 and linha <= 3 then
            return linha, coluna
        else
            print("Sua jogada foi INVÁLIDA! Por favor, jogue novamente...")
            ler_jogada(JOGADORES, X)
        end
    end
    io.write(string.format("%s, digite a sua jogada (Ex.: B3, A1, C2...): ",
                           JOGADORES[X]:upper()))
    return validar_jogada(io.read())
end

function preencher_tabuleiro(tabuleiro, POS_VAZIA, PECA, jogadores, index, LIN,
                             COL)
    if tabuleiro[LIN][COL] == POS_VAZIA then
        tabuleiro[LIN][COL] = PECA
    else
        msg =
            "%s, você tentou jogar em uma posição já preenchida. Jogue novamente!"
        print(msg:format(jogadores[index]))
        tabuleiro = preencher_tabuleiro(tabuleiro, POS_VAZIA, PECA,
                                        ler_jogada(jogadores, index), jogadores,
                                        index)
    end
    return tabuleiro
end

function validar_tabuleiro(PECAS, TABULEIRO, JOGADORES)
    vitoria = false
    vitorioso = "Ninguém"

    for _, PECA in ipairs(PECAS) do
        for i = 1, 3 do
            if TABULEIRO[i][1] == PECA and TABULEIRO[i][2] == PECA and
                TABULEIRO[i][3] == PECA then
                vitoria = true
                vitorioso = JOGADORES[_]
                break
            end
            if TABULEIRO[1][i] == PECA and TABULEIRO[2][i] == PECA and
                TABULEIRO[3][i] == PECA then
                vitoria = true
                vitorioso = JOGADORES[_]
                break
            end
        end
        if TABULEIRO[1][1] == PECA and TABULEIRO[2][2] == PECA and
            TABULEIRO[3][3] == PECA then
            vitoria = true
            vitorioso = JOGADORES[_]
            break
        elseif TABULEIRO[1][3] == PECA and TABULEIRO[2][2] == PECA and
            TABULEIRO[3][1] == PECA then
            vitoria = true
            vitorioso = JOGADORES[_]
            break
        end
    end
    return vitoria, vitorioso
end

function validar_velha(TABULEIRO, POS_VAZIA)
    contador = 0
    for i in ipairs(TABULEIRO) do
        for j in ipairs(TABULEIRO[i]) do
            if TABULEIRO[i][j] == POS_VAZIA then
                contador = contador + 1
            end
        end
    end
    return contador == 0
end
function jogo()

    repeat

        print("\x1b[2J\x1b[1;1H")
        abertura_jogo()

        SETA_BAIXO, SETA_DIREITA, POS_VAZIA = validar_SO()
        tabuleiro = criar_tabuleiro(POS_VAZIA)
        jogadores = player_names()
        print("\x1b[2J\x1b[1;1H")
        PECAS = {"X", "O"}

        while true do
            for _ in pairs(jogadores) do
                imprimir_tabuleiro(tabuleiro, SETA_BAIXO, SETA_DIREITA)

                preencher_tabuleiro(tabuleiro, POS_VAZIA, PECAS[_], jogadores,
                                    _, ler_jogada(jogadores, _))
                vitoria, vitorioso = validar_tabuleiro(PECAS, tabuleiro,
                                                       jogadores, POS_VAZIA)
                velha = validar_velha(tabuleiro, POS_VAZIA)
                print("\x1b[2J\x1b[1;1H")

                if vitoria then
                    trofeu = "            .-=========-.\
            \\'-=======-'/\
            _|   .=.   |_\
           ((|  {{1}}  |))\
            \\|   /|\\   |/\
             \\__ '`' __/\
               _`) (`_\
             _/_______\\_\
            /___________\\ "
                    msg_vitoria = "\t  PARABÉNS %s!\
     VOCÊ GANHOU O JOGO DA VELHA"
                    imprimir_tabuleiro(tabuleiro, SETA_BAIXO, SETA_DIREITA)
                    print(trofeu)
                    print(msg_vitoria:format(vitorioso:upper()))
                    break
                end

                if velha then
                    caveira = "                     .ed\"\"\"\" \"\"\"$$$$be.\
                   -\"           ^\"\"**$$$e.\
                 .\"                   '$$$c\
                /                      \"4$$b\
               d  3                      $$$$\
               $  *                   .$$$$$$\
              .$  ^c           $$$$$e$$$$$$$$.\
              d$L  4.         4$$$$$$$$$$$$$$b\
              $$$$b ^ceeeee.  4$$ECL.F*$$$$$$$\
  e$\"\"=.      $$$$P d$$$$F $ $$$$$$$$$- $$$$$$\
 z$$b. ^c     3$$$F \"$$$$b   $\"$$$$$$$  $$$$*\"      .=\"\"$c\
4$$$$L        $$P\"  \"$$b   .$ $$$$$...e$$        .=  e$$$.\
^*$$$$$c  %..   *c    ..    $$ 3$$$$$$$$$$eF     zP  d$$$$$\
  \"**$$$ec   \"   %ce\"\"    $$$  $$$$$$$$$$*    .r\" =$$$$P\"\"\
        \"*$b.  \"c  *$e.    *** d$$$$$\"L$$    .d\"  e$$***\"\
          ^*$$c ^$c $$$      4J$$$$$% $$$ .e*\".eeP\"\
             \"$$$$$$\"'$=e....$*$$**$cz$$\" \"..d$*\"\
               \"*$$$  *=%4.$ L L$ P3$$$F $$$P\"\
                  \"$   \"%*ebJLzb$e$$$$$b $P\"\
                    %..      4$$$$$$$$$$ \"\
                     $$$e   z$$$$$$$$$$%\
                      \"*$c  \"$$$$$$$P\"\
                       .\"\"\"*$$$$$$$$bc\
                    .-\"    .$***$$$\"\"\"*e.\
                 .-\"    .e$\"     \"*$c  ^*b.\
          .=*\"\"\"\"    .e$*\"          \"*bc  \"*$e..\
        .$\"        .z*\"               ^*$e.   \"*****e.\
        $$ee$c   .d\"                     \"*$.        3.\
        ^*$E\")$..$\"                         *   .ee==d%\
           $.d$$$*                           *  J$$$e*\
            \"\"\"\"\"                              \"$$$\""
                    msg_velha = "\t      Que pena, dois mestres jogando...\
\t\t%s ganhou este jogo!"
                    imprimir_tabuleiro(tabuleiro, SETA_BAIXO, SETA_DIREITA)
                    print(caveira)
                    print(msg_velha:format(vitorioso))
                    break
                end
            end
            if vitoria or velha then break end
        end
        pula_linha(2)
        print("Obrigado por jogar...\
Deseja jogar novamente (S/N)?")
        jogar_novamente = io.read()
    until jogar_novamente:upper() == "N"
end

jogo()
