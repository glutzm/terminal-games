-- Guess the Number
-- Autor: Gustavo Antonio Lutz de Matos - gustavo.almatos@gmail.com
-- Jogo desenvolvido acompanhando o canal Glider (https://www.youtube.com/channel/UCBFCipnenbWX-EhWn05r6aA)

function abertura_do_jogo()
    print("Bem Vindo ao Jogo Advinhe o Número\
Este jogo foi criado pelo Gustavo Antonio Lutz de Matos\
Como forma de aprender a utilizar a linguagem Lua\n")
end

function manual()
    print("Você deseja ler o manual do jogo (S/N)?")
    local resposta = io.read()
    if resposta:upper() == "S" then
        print("Este é um jogo de advinhação, onde o computador irá\
escolher um número aleatório que o jogador precisará descobrir por simples processo de tentativa e erro.\n")
    end
end

function criar_numero_aleatorio()
    seed = os.clock() * 10000000
    math.randomseed(seed)
    return math.random(1, 100)
end

function captura_palpite()
    while true do
        print("Digite o seu palpite: ")
        palpite = io.read()
        if type(tonumber(palpite)) == "number" then
            palpite = tonumber(palpite)
            if palpite > 100 or palpite < 1 then
                print("Seu palpite foi inválido, use um número entre 1 e 100.")
            else
                return palpite
            end
        else
            print("Por favor, digite um número!")
        end
    end
end

function compara_com_palpite(num_do_computador, palpite)
    if num_do_computador == palpite then
        return true
    else
        return false
    end
end

function imprime_interacao(numero, resultado_da_tentativa)
    if resultado_da_tentativa then
        print("Parabéns! Eu realmente estava pensando no número " .. numero)

    else
        print("Não, este não é o número que eu estava pensando :(")
        print("Que tal tentar novamente?")
    end
    return not resultado_da_tentativa
end

function partida(numero_secreto)
    palpite = captura_palpite()
    return imprime_interacao(numero_secreto,
                             compara_com_palpite(numero_secreto, palpite))

end

function main_loop()
    numero_secreto = criar_numero_aleatorio()
    continua_jogando = true
    while continua_jogando do continua_jogando = partida(numero_secreto) end
end

function jogo()
    print("\x1b[2J\x1b[1;1H")
    abertura_do_jogo()
    manual()
    repeat
        main_loop()
        print("Deseja jogar novamente (S/N)?")
        jogar_novamente = io.read()
    until jogar_novamente:upper() == "N"
end

jogo()
