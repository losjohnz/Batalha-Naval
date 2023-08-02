Program Batalha_Naval ;
// begin
  
   
  
  // -------------------------------------------------------------------------------------------
  //		Programa criado para simular o clássico jogo de Batalha Naval!
  //
  //		Autor: João Santos
  //		Contato: joao-sbs@hotmail.com
  //		Agradecimentos a todos os envolvidos na criação deste belo compilador!
  // -------------------------------------------------------------------------------------------
  
  
  
  
  //----------------------------------- // Area de declarações - programa principal //----------------------------------------------------------------------- //
  
  
  Uses Crt;
  
  Type
  
  XY = record
    X: integer;
    Y: Integer;
  end;                                                          
  
  Navio = Record
    ID: integer;
    Estado: Integer;
  end;
  
  Axel = record
    Posicao: XY;
    Estado: integer;
    ID: integer;
  end;
  
  Life = record
    MaxHP: Integer;
    HP: Integer;
    Dead: Boolean;
  end;
  
  Matriz = Array [1..15, 1..15] of Navio;
  
  KillList = array [1..5] of XY;
  
  VPosicao = record
    PLegal: boolean;
    PIlegal: KillList;
  end;
  
  Pool = record
    Pool: array [1..16] of integer;
    Posi: Integer;
    Quantidade: array [1..5] of integer;
  end;
  
  Informayshon = record
    Estado: Integer;
    Posicao: XY;
    ID: Integer;
    Continua: Integer;
    MaxContinua: Integer;
    Extra: XY;
    Direcao_Extra: Char;
  end;
  
  Blink = record
    posicao: XY;
    icone: char;
    color: byte;
  end;
  
  Frota = record
    Player: Integer;
    Axel: Integer;
  end;
  
  Combosa = record
    ID: Integer;
    Counter: Integer;
  end;
  
  Pontuacao = record
    Nome: Array [1..3] of char;
    Pontos: LongInt;
  end;
  
  SaveFile = record
    Save: Pontuacao;
    Difficulty: Char;
  end;
  
  Var
  
  
  SAIR, NOVO: Boolean;
  EstadoInicial: Integer;
  Arena: Matriz;
  LArenaATiroX, LArenaATiroY, NavioResX, NavioResY, MNavioResX, MNavioResY, POSICAO_HORIZONTAL, POSICAO_VERTICAL, StatusScreenX, StatusScreenY, NaviosCounterX, NaviosCounterY: Integer;  // Variáveis de posicionamento da UI
  Score: Integer;
  Score_List: Array [1..10] of Pontuacao;
  Difficulty: Char;
  Arq: File of Savefile;
  Directory: String;
  MemoryCard, MemoryCardDummy, MemoryCardDummy0: Array [1..11] of Savefile;
  I: Integer;
  
  //----------------------------------- // Procedure 1 //----------------------------------------------------------------------- //
  
  // Procedure Desenha Bordas, como o nome já indica, desenha as bordas de todas as "caixas" do programa
  
  Procedure Desenha_Bordas (corletra, corfundo, icone, PH, PV, DH, DV: integer; Horizontal, Vertical, Bugado, VideoAlto: Boolean);
  
  
  // PH e PV determinam aonde começa o INTERIOR da caixa. Ou seja, a Borda em sim começa -1x e -1y das coordenadas mostradas
  // DH e DV determinam a dimensão do INTERIOR da caixa. Ou seja, quantas linhas vazias existem dentro da caixa.
  // Portanto, ela funciona perfeitamente em conjuto com a função Window
  
  
  Var I: integer;
  
  begin
    textcolor				(corletra);
    textbackground	(corfundo);
    
    
    // DESENHA PAREDES HORIZONTAIS
    if Horizontal then begin
      for I:= 0 to DH + 1 do begin
        gotoxy					(PH - 1 + I, PV - 1);
        writeln					(chr(icone));   // 176
        gotoxy					(PH - 1 + I, PV + DV);
        writeln					(chr(icone));
      end;
      
      if Bugado then begin
        textcolor (black);                          // Aqui desenha-se uma borda adicional preta para evitar alguns bugs do terminal
        textbackground (black);
        gotoxy          (PH - 1 + DH + 2, PV - 1);
        writeln					(chr(icone));
        gotoxy					(PH - 1 + DH + 2, PV + DV);
        writeln					(chr(icone));
        textcolor				(corletra);
        textbackground	(corfundo);
      end;
      
    end;
    if Vertical then begin
      // DESENHA PAREDES VERTICAIS
      for I:= 0 to DV - 1 do begin
        gotoxy					(PH - 1, PV + I);
        writeln					(chr(icone));
        gotoxy					(PH + DH, PV + I);
        writeln					(chr(icone));
      end;
      
      if Bugado then begin
        for I:= 0 to DV - 1 do begin
          textcolor (black);
          textbackground (black);
          gotoxy					(PH +DH + 1, PV + I);
          writeln					(chr(icone));
          textcolor				(corletra);
          textbackground	(corfundo);
        end;
      end;
    end;
  end;
  
  
  //----------------------------------- // FIM Procedure 1 //----------------------------------------------------------------------- //
  
  
  //----------------------------------- // Procedure 2 //----------------------------------------------------------------------- //
  
  // Procedure Abrir_Tela_Inicial abre e controla todas as sub-procedures relacionadas com o funcionamento da tela inicial
  
  Procedure Abrir_Tela_Inicial (Var EstadoInicial: integer);
  
  Const
  
  POSICAO_HORIZONTAL = 25;
  POSICAO_VERTICAL = 3;
  DIMENSAO_HORIZONTAL = 50;
  DIMENSAO_VERTICAL = 10;
  AncoraTitleX = 12;
  AncoraTitleY = 3;
  AncoraMX= 73;
  AncoraMY= 4;
  
  
  Var
  
  I, Estado, Estado_Antigo: integer;
  key, U: char;
  
  
  
  //----------------------------------- // Sub-Procedure 2-1 //----------------------------------------------------------------------- //
  
  // Procedure Mover_Cursor_Inicial é responsável por mover o Cursor da tela Inicial
  
  
  procedure Mover_Cursor_Inicial (Estado_Antigo, Estado : integer);
  begin
    textbackground(black);
    case (Estado_Antigo) of
      1:	gotoxy							(POSICAO_HORIZONTAL + 19, POSICAO_VERTICAL + 17);
      2:	gotoxy							(POSICAO_HORIZONTAL + 12, POSICAO_VERTICAL + 18);
      3:	gotoxy							(POSICAO_HORIZONTAL + 12, POSICAO_VERTICAL + 21);
      4: 	gotoxy							(POSICAO_HORIZONTAL + 29, POSICAO_VERTICAL + 18);
      5: 	gotoxy							(POSICAO_HORIZONTAL + 29, POSICAO_VERTICAL + 21);
    end;
    write								('  ');
    
    textbackground(red);
    case	(Estado) of
      1:	gotoxy							(POSICAO_HORIZONTAL + 19, POSICAO_VERTICAL + 17);
      2:	gotoxy							(POSICAO_HORIZONTAL + 12, POSICAO_VERTICAL + 18);
      3:	gotoxy							(POSICAO_HORIZONTAL + 12, POSICAO_VERTICAL + 21);
      4: 	gotoxy							(POSICAO_HORIZONTAL + 29, POSICAO_VERTICAL + 18);
      5: 	gotoxy							(POSICAO_HORIZONTAL + 29, POSICAO_VERTICAL + 21);
    end;
    write								(#16:2);
    textcolor (black);
    textbackground (black);
  end;
  
  
  //----------------------------------- // FIM Sub-Procedure 2-1 //----------------------------------------------------------------------- //
  
  
  //----------------------------------- // Abrir_Tela_Inicial - Procedure 2 - START //----------------------------------------------------------------------- //
  
  
  Begin
    
    Estado := 2;
    U:=#219;
    CursorOff; // Remove Cursor
    
    
    Desenha_Bordas (black, red, 176, POSICAO_HORIZONTAL + round(DIMENSAO_HORIZONTAL/5) + 1, POSICAO_VERTICAL + 16, round(3*(DIMENSAO_HORIZONTAL/5)-1), 8, true, true, true, true);   // PAREDES DO MENU
    
    
    textbackground (black);
    textcolor (red);
    window (0,0,0,0);
    
    Gotoxy (AncoraMX,AncoraMY+3); Write('                ',U,U,'                  ');
    Gotoxy (AncoraMX,AncoraMY+4); Write('                ',U,U,'                  ');
    Gotoxy (AncoraMX,AncoraMY+5); Write('                ',U,U,'                  ');
    Gotoxy (AncoraMX,AncoraMY+6); Write('                ',U,U,'                  ');
    Gotoxy (AncoraMX,AncoraMY+7); Write('                                            ');
    Gotoxy (AncoraMX,AncoraMY+8); Write('                                            ');
    Gotoxy (AncoraMX+3,AncoraMY+9); Write(U,U,U,U,U,U,U,U,U,'    ',U,U,'    ',U,U,U,U,U,U,U,U,U);
    Gotoxy (AncoraMX,AncoraMY+10); Write('                                            ');
    Gotoxy (AncoraMX,AncoraMY+11); Write('                                            ');
    Gotoxy (AncoraMX,AncoraMY+12); Write('                ',U,U,'                  ');
    Gotoxy (AncoraMX,AncoraMY+13); Write('                ',U,U,'                  ');
    Gotoxy (AncoraMX,AncoraMY+14); Write('                ',U,U,'                  ');
    Gotoxy (AncoraMX,AncoraMY+15); Write('                ',U,U,'                  ');
    
    
    
    Gotoxy (AncoraTitleX, AncoraTitleY);   Write  ('__________   _____  ___________  _____   ___      /\   /\    _____   ');
    Gotoxy (AncoraTitleX, AncoraTitleY+1); Write  ('\______   \ /  _  \ \__    ___/ /  _  \ |   |    /  |_|  \  /  _  \  ');
    Gotoxy (AncoraTitleX, AncoraTitleY+2); Write  ('  |   |  _//  /_\  \  |    |   /  /_\  \|   |   /         \/  /_\  \ ');
    Gotoxy (AncoraTitleX, AncoraTitleY+3); Write  ('  |   |   \    |    \ |    |  /    |    \   |___\    _    /    |    \');
    Gotoxy (AncoraTitleX, AncoraTitleY+4); Write  (' /______  /____|__  / |____|  \____|__  /______ \\  | |  /\____|__  /');
    Gotoxy (AncoraTitleX, AncoraTitleY+5); Write  ('        \/        \/                  \/       \/ \/   \/         \/ ');
    
    
    Gotoxy (AncoraTitleX+8,AncoraTitleY+7); Write  ('   ______ |\   _____  ____   ___  _____   ___     ');
    Gotoxy (AncoraTitleX+8,AncoraTitleY+8); Write  ('   \     \| | /  _  \ \   \ /  / /  _  \ |   |    ');
    Gotoxy (AncoraTitleX+8,AncoraTitleY+9); Write  ('   /   |    |/  /_\  \ \   \  / /  /_\  \|   |    ');
    Gotoxy (AncoraTitleX+8,AncoraTitleY+10); Write ('  /    |\   |    |    \ \    / /    |    \   |___ ');
    Gotoxy (AncoraTitleX+8,AncoraTitleY+11); Write ('  \____| \  /____|__  /  \  /  \____|__  /______ \');
    Gotoxy (AncoraTitleX+8,AncoraTitleY+12); Write ('          \/        \/    \/           \/       \/');
    
    textbackground (red);
    
    textcolor (black);
    
    gotoxy							(POSICAO_HORIZONTAL + 12, POSICAO_VERTICAL + 18);
    write								(#16:2, 'Start Game');
    gotoxy							(POSICAO_HORIZONTAL + 14, POSICAO_VERTICAL + 21);
    write								('Score');
    gotoxy							(POSICAO_HORIZONTAL + 31, POSICAO_VERTICAL + 18);
    write								('Options');
    gotoxy							(POSICAO_HORIZONTAL + 31, POSICAO_VERTICAL + 21);
    write								('Exit');
    
    
    textcolor (black);
    textbackground (black);
    
    
    repeat
      Estado_Antigo:= Estado;
      CursorOff;
      Key:= (readkey);
      
      
      case (key) of
        #0: case (readkey) of
          #72:	case (Estado) of    //PARA CIMA
            //     1:	Estado:= 5;
            2:  Estado:= 3;
            3:	Estado:= 2;
            4:  Estado:= 5;
            5:  Estado:= 4;
          end;
          #80:	case (Estado) of 		//PARA BAIXO
            //      1: 	Estado:= 2;
            2:	Estado:= 3;
            3:	Estado:= 2;
            4: 	Estado:= 5;
            5:	Estado:= 4;
          end;
          #75:	case (Estado) of		//PARA ESQUERDA
            //     1:	Estado:= 2;
            2:	Estado:= 4;
            3:	Estado:= 5;
            4:	Estado:= 2;
            5:	Estado:= 3;
          end;
          #77:	case (ESTADO) of 		//PARA DIREITA
            //      1:	Estado:= 4;
            2:	Estado:= 4;
            3:	Estado:= 5;
            4:	Estado:= 2;
            5:	Estado:= 3;
          end;
        end;
        #13: begin                  //ENTER
          EstadoInicial := Estado;
          Exit;
        end;
      end;
      
      if Estado <> Estado_Antigo then Mover_Cursor_Inicial (Estado_Antigo, Estado);
      
    until(false);
  end;
  
  
  //----------------------------------- // FIM Procedure 2 //----------------------------------------------------------------------- //
  
  
  //----------------------------------- // Procedure 3 //----------------------------------------------------------------------- //
  
  // Procedure Centraliza_Texto é utilizada em vários momentos para facilitar a centralização do texto em uma janela de texto
  // Em vários momentos, porém, é utilizado a boa e velha "tentativa e erro" mesmo
  
  procedure Centraliza_Texto (String_T: string; Espaco_Total, QColunas, LinhasP, Paragrafo: integer; Var T: XY);
  
  Var Espaco_Disponivel, A, B: integer;
  
  begin
    
    
    
    Espaco_Disponivel:= Espaco_Total - Length (String_T);
    
    A:= trunc(Espaco_Disponivel/2);
    B:= trunc(A/Qcolunas);
    A:= A+1;
    T.Y:= B + 1;
    T.X:= A-(B*QColunas);
    T.Y:= T.Y - LinhasP;
    if Paragrafo <> 0 then
    T.X:= Paragrafo;
    gotoxy(T.X, T.Y);
    write (String_T);
    
  end;
  
  
  //----------------------------------- // FIM Procedure 3 //----------------------------------------------------------------------- //
  
  
  //----------------------------------- // Procedure 4 //----------------------------------------------------------------------- //
  
  
  procedure Mover_Cursor_Navios (Estado, Q_Estado: Integer; Tposicao, Espacamento: XY; VerticalTRUE: Boolean; Var Estado_sai: Integer);
  
  // Procedure Mover_Cursor_Navios é responsável pelo movimento do cursor durante o posicionamento inicial dos Navios antes da partida começar
  
  var Estado_Antigo : integer;
  
  // Estado é a posição do cursor (ou navio selecionado)
  // Espaçamento é o espaço que o ícone do cursor move de uma opção para outra
  
  
  begin
    
    Estado_Antigo := Estado;
    
    case (readkey) of
      #72:	if (Estado) = 1 then
      Estado:= Q_estado
      else
      Estado:= Estado - 1;
      #80:	if (Estado) = Q_estado then
      Estado:= 1
      else
      Estado:= Estado + 1;
      
      
      #75: if not VerticalTRUE then begin
        if (Estado) = 1 then
        Estado:= Q_estado
        else
        Estado:= Estado - 1;
      end;
      #77: if not VerticalTRUE then begin
        if (Estado) = Q_estado then
        Estado:= 1
        else
        Estado:= Estado + 1;
      end;
    end;
    
    
    
    if Estado <> Estado_Antigo then begin
      If VerticalTRUE then begin  // SE MOVIMENTO VERTICAL
        textbackground(black);
        textcolor (white);
        gotoxy							(Tposicao.x, Tposicao.y + ((Estado_Antigo-1)*Espacamento.y));
        write								(' ');
        
        gotoxy							(Tposicao.x, Tposicao.y + ((Estado-1)*Espacamento.y));
        write								(#4);
      end
      
      else begin           			 // SE MOVIMENTO HORIZONTAL
        textbackground(black);
        textcolor (white);
        gotoxy							(Tposicao.x + ((Estado_Antigo-1)*Espacamento.x), Tposicao.y);
        write								(' ');
        
        gotoxy							(Tposicao.x + ((Estado-1)*Espacamento.x), Tposicao.y);
        write								(#4);
      end;
    end;
    
    Estado_sai:= Estado
  end;
  
  
  //----------------------------------- // FIM Procedure 4 //----------------------------------------------------------------------- //
  
  
  //----------------------------------- // Procedure 5 //----------------------------------------------------------------------- //
  
  
  Procedure Cposicao (posicao: XY; V_REAL : boolean; Var Tposicao: XY);
  
  // Cposição converte as coordenadas da Arena de batalha (15 x 15) para as coordenadas reais no Console para que o ícone correto possa ser desenhado
  
  var
  Inutil: XY;
  
  begin
    if V_REAL then begin
      Inutil.x:= (4*posicao.x)-2;
      Inutil.y:= (2*posicao.y)-1;
    end
    else begin
      Inutil.x:= trunc((posicao.x+2)/4);
      Inutil.y:= trunc((posicao.y+1)/2);
    end;
    Tposicao:= Inutil;
  end;
  
  
  //----------------------------------- // FIM Procedure 5 //----------------------------------------------------------------------- //
  
  
  //----------------------------------- // Procedure 6 //----------------------------------------------------------------------- //
  
  
  Procedure Abrir_Arena_Jogo (Var Arena : Matriz);
  
  // Procedure Abrir_Arena_Jogo é responsável por abrir e controlar todas as sub-procedures relacionadas a tela anterior ao jogo principal
  // aonde acontece o pré-posicionamento dos navios pelo jogador
  
  
  Const
  
  DIMENSAO_HORIZONTAL = 59;
  DIMENSAO_VERTICAL = 29;
  AREA_ARENA = DIMENSAO_HORIZONTAL*DIMENSAO_VERTICAL;
  Q_EstadoN = 5;
  Q_EstadoH = 2;
  ColorP = brown;
  ColorI = lightred;
  ColorC = yellow;
  
  
  Var
  
  Arena_Dummy, Arena_Axel: Matriz;
  Posicao_Legal: VPosicao;
  I, J, num, Estado, Estado_Antigo, Estado_Alternativo, Estado_H: Integer;
  ID: pool;
  Texto: String;
  letra, key, INICIA: Char;
  Tposicao, Espacamento: XY;
  Icone: array [1..11] of char = (#4, #254, #5, #6, #3, #4, #4, #4, #5, #6, #3);
  Fix: array [1..11, 1..5] of XY;
  
  
  //----------------------------------- // Sub-Procedure 6-1 //----------------------------------------------------------------------- //
  
  
  Procedure Set_Window (Tipo: Char);
  
  // Procedure Set_Window é utilizada para facilitar a criação de várias windows específicas ao longo da execução do programa
  
  
  begin
    case (Tipo) of
      'A': Window	(StatusScreenX +1, StatusScreenY +35 +1, StatusScreenX +1 +(18-1), StatusScreenY +35 +1 +(18-1));  // 18-1 => (Dimensao total -1)
      'B': Window	(StatusScreenX +20 +1 +1, StatusScreenY +35 +1, StatusScreenX +20 +1 +1 +(15-1), StatusScreenY +35 +1 +(18-1)); // +20 (dimensao total) +1 divisoria e +1 window
      'C': Window (StatusScreenX +37 +2 +1, StatusScreenY +35 +1, StatusScreenX +37 +2 +1 +(18-1), StatusScreenY +35 +1 +(18-1));
      'D': Window (POSICAO_HORIZONTAL, POSICAO_VERTICAL, POSICAO_HORIZONTAL+DIMENSAO_HORIZONTAL-1, POSICAO_VERTICAL+DIMENSAO_VERTICAL-1); // Dimensao da arena
      else Exit;
    end;
  end;
  
  
  // Arena jogo tem várias janelas. Essa procedure seleciona a janela adequada para alterar na interface gráfica.
  
  
  //----------------------------------- // FIM Sub-Procedure 6-1 //----------------------------------------------------------------------- //
  
  
  //----------------------------------- // Sub-Procedure 6-2 //----------------------------------------------------------------------- //
  
  
  Procedure Desenha_Navio_Selecao (Estado, FX, FY: integer);
  
  // Procedure Desenha_Navios desenha uma representação da forma do navio durante o seu posicionamento
  
  begin
    Set_Window ('C');
    clrscr;
    case (Estado) of
      //------------- HIDROAVIAO
      1: begin
        Desenha_Bordas (colorP, black, 4, FX + 9-3, FY + 9+2, 2, 2, true, true, false, false);
        Desenha_Bordas (colorP, black, 4, FX + 9+3, FY + 9+2, 2, 2, true, true, false, false);
        Desenha_Bordas (colorP, black, 4, FX + 9, FY + 9-2, 2, 2, true, true, false, false);
      end;
      //------------- SUBMARINO
      2: Desenha_Bordas (colorP, black, 4, FX + 9, FY + 9, 2, 2, true, true, false, false);
      //------------- CRUZADOR
      3: begin
        Desenha_Bordas (colorP, black, 4, FX + 9-2, FY + 9, 2, 2, true, true, false, false);
        Desenha_Bordas (colorP, black, 4, FX + 9+2, FY + 9, 2, 2, true, true, false, false);
      end;
      //------------- ENCOURAÇADO
      4: begin
        Desenha_Bordas (colorP, black, 4, FX + 9-6, FY + 9, 2, 2, true, true, false, false);
        Desenha_Bordas (colorP, black, 4, FX + 9-2, FY + 9, 2, 2, true, true, false, false);
        Desenha_Bordas (colorP, black, 4, FX + 9+2, FY + 9, 2, 2, true, true, false, false);
        Desenha_Bordas (colorP, black, 4, FX + 9+6, FY + 9, 2, 2, true, true, false, false);
      end;
      //------------- PORTA AVIAO
      5: begin
        Desenha_Bordas (colorP, black, 4, FX + 9-6, FY + 9, 2, 2, true, true, false, false);
        Desenha_Bordas (colorP, black, 4, FX + 9-3, FY + 9, 2, 2, true, false, false, false);
        Desenha_Bordas (colorP, black, 4, FX + 9, FY + 9, 2, 2, true, true, false, false);
        Desenha_Bordas (colorP, black, 4, FX + 9+3, FY + 9, 2, 2, true, false, false, false);
        Desenha_Bordas (colorP, black, 4, FX + 9+6, FY + 9, 2, 2, true, true, false, false);
      end
      else Exit;
    end;
  end;
  
  
  //----------------------------------- // FIM Sub-Procedure 6-2 //----------------------------------------------------------------------- //
  
  
  //----------------------------------- // Sub-Procedure 6-3 //----------------------------------------------------------------------- //
  
  
  Procedure Posicionar_Navios (Estado: integer; Var INICIA : char);
  
  // Procedure Posicionar_Navios é responsável por chamar e executar todas as procedures utilizadas durante o posicionamento dos navios na arena
  
  Const
  FH= 4;  // Fator Horizontal
  FV= 2; 	// Fator Vertical
  DH= 15; // Dimensao Horizontal Escalada
  DV= 15; // Dimensao Vertical Escalada
  
  Var
  posicao, posicao_antiga: XY;  // Posicao Central in-game
  Tposicao: XY;  // True Posicao
  Key: char;
  Movimento_Valido: boolean;
  MAXI: Integer;
  
  
  //----------------------------------- // Sub-Procedure 6-3-1 //----------------------------------------------------------------------- //
  
  
  Procedure Valida_Posicao (Estado: integer; Var retorno: VPosicao);
  
  // Procedure Valida_Posicao analisa se o movimento executado durante o posicionamento dos navios é válido
  // (para evitar situações como o navio saindo para fora da arena)
  
  Var I, J:integer = 1;
  CoordenadaX, CoordenadaY, Estado_Backup: integer;
  
  begin
    retorno.Plegal:= TRUE;
    for I:=1 to 5 do begin
      retorno.PIlegal[I].x:= 0;
      retorno.PIlegal[I].y:= 0;
    end;
    
    I:= 1;
    
    repeat
      CoordenadaX:= posicao.x + Fix[Estado][I].x;
      CoordenadaY:= posicao.y + Fix[Estado][I].y;
      
      If (Arena [CoordenadaX, CoordenadaY].estado <> 0) then begin
        retorno.PIlegal[J].x:= CoordenadaX;
        retorno.PIlegal[J].y:= CoordenadaY;
        inc (J);
      end;
      Inc(I);
      
    until I=MAXI+1;
    
    For I:= 1 to 5 do begin
      if retorno.PIlegal[I].x <> 0 then retorno.Plegal:= FALSE;
      if retorno.PIlegal[I].y <> 0 then retorno.Plegal:= FALSE;
    end;
  end;
  
  
  //----------------------------------- // FIM Sub-Procedure 6-3-1 //----------------------------------------------------------------------- //
  
  
  //----------------------------------- // Sub-Procedure 6-3-2 //----------------------------------------------------------------------- //
  
  
  Procedure Mover_Posicao (Posicao_Antiga, Posicao: XY; Estado: integer; Rotacao: Boolean; var Retorno: Matriz);
  
  // Procedure Mover_Posicao realiza a movimentação dos navios na interface gráfica e também nas variáveis internas de controle
  
  Var
  
  Tposicao: XY;
  A, B: char;
  C:char = ' ';
  CoordenadaX, CoordenadaY, TcoordenadaX, TcoordenadaY, Estado_Backup: integer;
  I: integer =1;
  Overlap: Vposicao;
  
  begin
    
    A:= Icone[estado];
    Estado_Backup:= Estado;
    
    textcolor (colorC);                             					 // amarelo, cor peça padrão
    If ((key= #13) AND (Posicao_Antiga.x = Posicao.x) AND (Posicao_Antiga.y = Posicao.y)) then  textcolor (colorP); // Para a peça ficar com a ColorP e dar a impressao de "coloquei a peça"
    If Rotacao then Estado:= Estado_Antigo;
    Cposicao (posicao_antiga, true, Tposicao);
    
    repeat
      CoordenadaX:= posicao_antiga.x + Fix[Estado][I].x;
      CoordenadaY:= posicao_antiga.y + Fix[Estado][I].y;       // Posição é o valor relativo a arena 15x15, Tposição é o valor real
      TCoordenadaX:= Tposicao.x + (Fix[Estado][I].x*FH);
      TCoordenadaY:= Tposicao.y + (Fix[Estado][I].y*FV);       // Coordenada x/y são os valores relativos, Tcoordenada x/y são os valores reais
      
      gotoxy (TCoordenadaX, TCoordenadaY);
      if Arena[CoordenadaX, CoordenadaY].estado <> 0 then begin
      textcolor (colorP); B:= Icone[Arena[CoordenadaX, CoordenadaY].estado]; write (B); textcolor (ColorC); end else write (C);
      inc(I);
      
    until I=MAXI+1;
    
    I:=1;
    Estado:= Estado_Backup;
    Cposicao (posicao, true, Tposicao);
    If NOT (key= #13) then Valida_Posicao (Estado, Overlap);
    
    repeat
      CoordenadaX:= posicao.x + Fix[Estado][I].x;
      CoordenadaY:= posicao.y + Fix[Estado][I].y;
      TCoordenadaX:= Tposicao.x + (Fix[Estado][I].x*FH);
      TCoordenadaY:= Tposicao.y + (Fix[Estado][I].y*FV);
      
      gotoxy (TCoordenadaX, TCoordenadaY); Retorno [CoordenadaX, CoordenadaY].estado:= Estado;
      if (key= #13) then begin
        Retorno [CoordenadaX, CoordenadaY].estado:= Estado;
        Retorno[CoordenadaX, CoordenadaY].ID:= ID.Pool[ID.Posi];
      end;
      if not Overlap.Plegal AND NOT (key= #13) then textcolor (ColorI);
      if not(key= #8) then
      write (A);
      inc(I);
      
    until I=MAXI+1;
    textcolor (colorC);
  end;
  
  
  //----------------------------------- // FIM Sub-Procedure 6-3-2 //----------------------------------------------------------------------- //
  
  
  //----------------------------------- // Sub-Procedure 6-3-3 //----------------------------------------------------------------------- //
  
  
  procedure DELETA_NAVIO (PosicaoIlegal : KillList; Var ID: Pool; Var Arena: Matriz);
  
  // Procedure DELETA_NAVIO é responsável por apagar os navios selecionados durante o posicionamento dos mesmos
  
  var
  
  I, J, K, W: integer = 1;
  IDList: Array [1..5] of integer = (0, 0, 0, 0, 0);
  Kill: array [1..25] of XY;
  TPosicao: XY;
  IDRepetido: boolean;
  Estado_Alternativo: integer;
  Dummy: Matriz;
  
  begin
    
    for I:= 1 to 25 do begin
      kill[I].x := 0;
      kill[I].y := 0;
    end;
    
    I:=1;
    
    while  K <= 5 do begin
      If ((PosicaoIlegal[K].x <> 0) AND (PosicaoIlegal[K].y <> 0)) then begin
        IDRepetido:= FALSE;
        for J:=1 to 5 do begin
          If Arena[PosicaoIlegal[K].x, PosicaoIlegal[K].y].ID = IDList [J] then
          IDRepetido:= TRUE;
        end;
        if not IDRepetido then begin                                               	// Se ID não Repetido
          IDList[I]:= Arena[PosicaoIlegal[K].x, PosicaoIlegal[K].y].ID;            	// Adiciona ID à Lista de ID's a serem Apagados
          Dec (ID.posi);                                                           	// Diminui a Posicão da lista de Pool de ID's
          ID.Pool[ID.posi]:= IDList[I];                                            	// Retorna o ID à Lista
          Set_Window ('B');                                                        	// Muda Janela para a de Seleção de Navios
          case (Arena[PosicaoIlegal[K].x, PosicaoIlegal[K].y].Estado) of
            1, 6, 7, 8: begin
            Estado_Alternativo:= 1; Gotoxy (15, 4); end;                          	// Aumenta o número no menu de seleção (devolve o navio a pool)
            2: begin
            Estado_Alternativo:= 2; Gotoxy (15, 7); end;
            3, 9: begin
            Estado_Alternativo:= 3; Gotoxy (15, 10); end;
            4, 10: begin
            Estado_Alternativo:= 4; Gotoxy (15, 13); end;
            5, 11: begin
            Estado_Alternativo:= 5; Gotoxy (15, 16); end;
          end;
          Inc(ID.Quantidade[Estado_Alternativo]);
          if ID.Quantidade[Estado_Alternativo] = (6 - Estado_Alternativo)
          then textcolor (white)
          else textcolor (yellow);
          write (ID.Quantidade[Estado_Alternativo]);
          textcolor (yellow);
          Inc (I);
        end;
        Inc (K);
      end
      else K:=100; // Sai do Loop
    end;
    
    Set_Window ('D'); TextColor (Yellow);
    I:= 1;
    J:= 1;
    K:= 1;
    
    while W <=5 do begin
      If IDlist[W] <> (0) then begin                       			// Gera as Posições a serem Apagadas
        for J:= 1 to 15 do begin
          for I:= 1 to 15 do begin
            if Arena[I,J].ID = IDlist[W] then begin             // Se o ID nessa posição da arena da match no ID da lista
              Kill[K].x := I;
              Kill[K].y := J;
              Arena[I,J].ID := 0; Arena[I,J].Estado := 0;       // Deleta posicões no Controle Arena
              inc (K);
            end;
          end;
        end;
        Inc (W);
      end
      else W:=100; // Sai do Loop
    end;
    
    I:=1;
    
    while I <=25 do begin
      If ((Kill[I].x <> 0) AND (Kill[I].y <> 0)) then begin   // Deleta posições Gráficas
        Cposicao (Kill[I], true, Tposicao);
        gotoxy (Tposicao.x, Tposicao.y);
        write (' ');
        inc (I);
      end
      else I:=100; // Sai do Loop
    end;
    
    I:=1;
    
    Mover_Posicao (Posicao_Antiga, Posicao, Estado, false, Dummy);   // Para que as peças do cursor deixem de ser vermelhas
    
  end;
  
  
  //----------------------------------- // FIM Sub-Procedure 6-3-3 //----------------------------------------------------------------------- //
  
  
  //----------------------------------- // Posicionar_Navios - Sub-Procedure 6-3 - START //----------------------------------------------------------------------- //
  
  
  begin   // POSICIONAR_NAVIOS                      // Esse trecho inicial do posicionar navios só é chamado quando vc seleciona um navio pra posicionar. Como não tem posição antiga ainda, ele usa o placeholder 8x8.
    
    If ID.Quantidade[Estado] = 0 then exit;
    Set_Window ('D');
    posicao.x:= round(DH/2);
    posicao.y:= DV;
    posicao_antiga.x:= 8;
    posicao_antiga.y:= 8;
    
    case (Estado) of                              	// Os 11 Estados aqui representam os navios com a rotação incluída. Cada navio rotacionado conta como um Estado novo.
      1, 6, 7, 8: MAXI:= 3;                         //Então no total são 11 variantes de navios
      2: MAXI:= 1;
      3, 9: MAXI:= 2;
      4, 10: MAXI:= 4;
      5, 11: MAXI:= 5;
    end;
    
    Mover_Posicao (Posicao_antiga, Posicao, Estado, False, Arena_Dummy);
    
    repeat   // Stand By...
      
      //----------------------------------------- TODOS OS NAVIOS FORAM ESGOTADOS --------------------------------------------------------
      
      If ((ID.Quantidade[1]= 0)AND(ID.Quantidade[2]= 0)AND(ID.Quantidade[3]= 0)AND(ID.Quantidade[4]= 0)AND(ID.Quantidade[5]= 0)) then begin
        gotoxy (1, (Estado_Alternativo*3)+1);                
        write (' ');
        Set_Window ('A');
        clrscr; textcolor(lightgray);
        Centraliza_Texto (' Iniciar Partida?', 324, 18, 1, 1, Tposicao);
        Centraliza_Texto (' SIM          NAO', 324, 18, -1, 1, Tposicao);
        gotoxy (tposicao.x,tposicao.y); write (#4);
        Espacamento.x := 13; Espacamento.y := 0;
        repeat
          Key:= (readkey);
          Cursoroff;
          If (key) = (#0) then  Mover_Cursor_Navios (Estado_H, 2, Tposicao, Espacamento, false, Estado_H);      
          
          If ((key = #13) AND (Estado_H = 2)) OR (Key = #8) then begin  
            key:= #0;
            Valida_Posicao (Estado, Posicao_Legal);
            Deleta_Navio (Posicao_Legal.PILegal, ID, Arena);
            Set_Window ('A');
            clrscr; textcolor(lightgray);
            Estado_H:=1;
            Centraliza_Texto ('SELECIONE os'+#13#10+' Navios desejados!' +#13#10+ ' <ENTER>'+#13#10+' Para posicionar!' +#13#10#13#10+ ' <SPACEBAR>'+#13#10+' Para rotacionar!' +#13#10#13#10+ ' <DELETE>'+#13#10+' Para remover!' +#13#10#13#10+ ' <BACKSPACE>'+#13#10+' Para voltar!', 324, 18,2, 2, Tposicao);
            Set_Window ('B');
            gotoxy (1, (Estado_Alternativo*3)+1); write (#4);
            Espacamento.y:= 3; Tposicao.x:= 1; Tposicao.y:= 4;
            Movimento_Valido:= FALSE;
            break;  			//break aqui sai do "repeat". Necessário senão o If de baixo é executado
            end;
            If (key = #13) AND (Estado_H = 1) then begin
              INICIA:= ('Y');
              exit;  
            end;
          until (false);
        end
        
        // -------------------------------------------------------------------------------------------------------------------------------------
        
        else begin
          if ID.Quantidade[Estado_Alternativo] = 0 then exit;               
          Set_Window ('D');
          Key:= (readkey);
          Posicao_antiga:= Posicao;
          Movimento_Valido:= TRUE;
          Cursoroff;
          case (key) of
            #0: case (readkey) of
              #72: begin //CIMA
                dec (Posicao.y);
              end;
              #80: begin // BAIXO
                inc (Posicao.y);
              end;
              #75: begin // ESQUERDA
                dec (Posicao.x);
              end;
              #77: begin  //DIREITA
                inc (Posicao.x);
              end;
              #83: begin //DELETE
                Valida_Posicao (Estado, Posicao_Legal);
                If not Posicao_Legal.PLegal then
                Deleta_Navio (Posicao_Legal.PILegal, ID, Arena);
              end;
            end;
            #13: begin //ENTER
              Valida_Posicao (Estado, Posicao_Legal);
              If Posicao_Legal.PLegal then begin
                Mover_Posicao (Posicao_Antiga, Posicao, Estado, False, Arena);
                Set_Window ('B');
                case (Estado_Alternativo) of
                  1: Gotoxy (15, 4);
                  2: Gotoxy (15, 7);
                  3: Gotoxy (15, 10);
                  4: Gotoxy (15, 13);
                  5: Gotoxy (15, 16);
                end;
                Dec(ID.Quantidade[Estado_Alternativo]);
                if ID.Quantidade[Estado_Alternativo] = 0 then textcolor(red);
                write (ID.Quantidade[Estado_Alternativo]);
                if ID.Posi < 16 then begin
                  ID.Pool[ID.Posi]:= 0;
                  inc (ID.Posi);
                end;
              end;
            end;
            
            #8: begin // BACKSPACE
              Mover_Posicao (Posicao_Antiga, Posicao, Estado, False, Arena_Dummy);
            end;
            #32: begin // SPACEBAR
              Estado_Antigo:= Estado;
              If (Estado = 1) OR (Estado = 2) OR (Estado = 3) OR (Estado = 4) OR (Estado = 5) then Estado_Alternativo:= Estado;
              case (Estado) of
                1: Estado:= 6;
                3: Estado:= 9;
                4: Estado:= 10;
                5: Estado:= 11;
                6: Estado:= 7;
                7: Estado:= 8;
                8: Estado:= 1;
                9: Estado:= 3;
                10: Estado:= 4;
                11: Estado:= 5;
              end;
            end;
          end;
          
          Case (Estado) Of
            1: If (Posicao.x < 2) OR (Posicao.x > 14) OR (Posicao.y <2) OR (Posicao.y > 15) then Movimento_Valido:= FALSE;    // triangulo
            2: If (Posicao.x < 1) OR (Posicao.x > 15) OR (Posicao.y <1) OR (Posicao.y > 15) then Movimento_Valido:= FALSE;    // 1 bloco
            3: If (Posicao.x < 1) OR (Posicao.x > 14) OR (Posicao.y <1) OR (Posicao.y > 15) then Movimento_Valido:= FALSE;    // 2 blocos H
            4: If (Posicao.x < 2) OR (Posicao.x > 13) OR (Posicao.y <1) OR (Posicao.y > 15) then Movimento_Valido:= FALSE;    // 4 blocos H
            5: If (Posicao.x < 3) OR (Posicao.x > 13) OR (Posicao.y <1) OR (Posicao.y > 15) then Movimento_Valido:= FALSE;    // 5 blocos H
            6: If (Posicao.x < 1) OR (Posicao.x > 14) OR (Posicao.y <2) OR (Posicao.y > 14) then Movimento_Valido:= FALSE;    // triangulo topo para direita    :.
            7: If (Posicao.x < 2) OR (Posicao.x > 14) OR (Posicao.y <1) OR (Posicao.y > 14) then Movimento_Valido:= FALSE;    // triangulo topo para baixo      *.*
            8: If (Posicao.x < 2) OR (Posicao.x > 15) OR (Posicao.y <2) OR (Posicao.y > 14) then Movimento_Valido:= FALSE;    // triangulo topo para esquerda  .:
            9: If (Posicao.x < 1) OR (Posicao.x > 15) OR (Posicao.y <1) OR (Posicao.y > 14) then Movimento_Valido:= FALSE;    // 2 blocos V
            10: If (Posicao.x < 1) OR (Posicao.x > 15) OR (Posicao.y <2) OR (Posicao.y > 13) then Movimento_Valido:= FALSE;   // 4 blocos V
            11: If (Posicao.x < 1) OR (Posicao.x > 15) OR (Posicao.y <3) OR (Posicao.y > 13) then Movimento_Valido:= FALSE;   // 5 blocos V
          end;
          
          If Movimento_Valido then begin
            If Key = #32 then
            Mover_Posicao (Posicao_Antiga, Posicao, Estado, true, Arena_Dummy);
            If (Posicao_Antiga.x <> Posicao.x) OR (Posicao_Antiga.y <> Posicao.y) then
            Mover_Posicao (Posicao_Antiga, Posicao, Estado, false, Arena_Dummy)
          end
          else begin
            If Key = #32 then Estado:= Estado_Antigo;
            Posicao:= Posicao_Antiga;
          end;
        end;
      until Key = (#8);
      
    end;
    
    
    //----------------------------------- // FIM Sub-Procedure 6-3 //----------------------------------------------------------------------- //
    
    
    //----------------------------------- // Abrir_Arena_Jogo - Procedure 6 - START //----------------------------------------------------------------------- //
    
    
    begin
      
      
      // Esvazia Arena
      For J:= 1 to 15 do begin
        for I:= 1 to 15 do begin
          Arena[I,J].ID:=0;
          Arena[I,J].Estado:=0;
        end;
      end;
      

      // FIX determina a posição das peças do navio depe.nde.ndo do Estado
      
      Fix[1][1].x:= -1; Fix[1][2].x:= 0; Fix[1][3].x:= 1;        //.*.
      Fix[6][1].x:= 0; Fix[6][2].x:= 0; Fix[6][3].x:= 1;         //:.
      Fix[7][1].x:= -1; Fix[7][2].x:= 0; Fix[7][3].x:= 1;        //*.*
      Fix[8][1].x:= -1; Fix[8][2].x:= 0; Fix[8][3].x:= 0;        //.:
      Fix[3][1].x:= 0; Fix[3][2].x:= 1;                          // .. H
      Fix[4][1].x:= -1; Fix[4][2].x:= 0; Fix[4][3].x:= 1; Fix[4][4].x:= 2;     //.... H
      Fix[5][1].x:= -2; Fix[5][2].x:= -1; Fix[5][3].x:= 0; Fix[5][4].x:= 1; Fix[5][5].x:= 2;   //..... H
      
      Fix[1][1].y:= 0 ; Fix[1][2].y:= -1; Fix[1][3].y:= 0;       //.*.
      Fix[6][1].y:= -1; Fix[6][2].y:= 1; Fix[6][3].y:= 0;        //:.
      Fix[7][1].y:= 0; Fix[7][2].y:= 1; Fix[7][3].y:= 0;         //*.*
      Fix[8][1].y:= 0; Fix[8][2].y:= -1; Fix[8][3].y:= 1;        //.:
      Fix[9][1].y:= 0; Fix[9][2].y:= 1;                         // .. V
      Fix[10][1].y:= -1; Fix[10][2].y:= 0; Fix[10][3].y:= +1; Fix[10][4].y:= +2;        //.... V
      Fix[11][1].y:= -2; Fix[11][2].y:= -1; Fix[11][3].y:= 0; Fix[11][4].y:= +1; Fix[11][5].y:= +2;  //..... V
      
      
      
      // DESENHA ARENA DE BATALHA
      textbackground	(black);
      clrscr;
      I:= 2;
      repeat
        Desenha_Bordas (cyan ,black, 240, POSICAO_HORIZONTAL, POSICAO_VERTICAL + I, DIMENSAO_HORIZONTAL, 1, true, false, false, true); // LINHAS H
        Inc (I,4);
      until I >= DIMENSAO_VERTICAL - 2;
      I:= 4;
      repeat
        Desenha_Bordas (cyan, black, 221 {124}, POSICAO_HORIZONTAL + I, POSICAO_VERTICAL, 3, DIMENSAO_VERTICAL, false, true, false, true);  // LINHAS V
        Inc (I,8);
      until I >= DIMENSAO_HORIZONTAL - 3;
      Desenha_Bordas (cyan, black, 219, POSICAO_HORIZONTAL, POSICAO_VERTICAL, DIMENSAO_HORIZONTAL, DIMENSAO_VERTICAL, true, true, false, true);  // BORDA
      I:= 0;
      letra := ('A');
      repeat
        gotoxy (POSICAO_HORIZONTAL - 4, POSICAO_VERTICAL + I);   // TAG DE LETRAS
        textcolor (white);
        write	(letra,'->');
        inc (letra);
        inc (I,2);
      until letra = ('P');
      I:= 1;
      repeat
        gotoxy (POSICAO_HORIZONTAL + I, POSICAO_VERTICAL - 2);   //TAG DE NUMEROS
        textcolor (white);
        inc (num);
        write (num);
        inc (I,4);
      until num = (15);
      
      
      Desenha_Bordas (lightgray, black, 219, StatusScreenX + 21, StatusScreenY + 35, 17, 20, false, true, false, true);               	// Caixa no meio
      Desenha_Bordas (lightgray, black, 219, StatusScreenX, StatusScreenY + 35, DIMENSAO_HORIZONTAL, 20, true, true, false, true);    	// Caixa maior
      
      
      Set_Window ('A');
      clrscr;
      textcolor (white);
      Centraliza_Texto ('SELECIONE os'+#13#10+' Navios desejados!' +#13#10+ ' <ENTER>'+#13#10+' Para posicionar!' +#13#10#13#10+ ' <SPACEBAR>'+#13#10+' Para rotacionar!' +#13#10#13#10+ ' <DELETE>'+#13#10+' Para remover!' +#13#10#13#10+ ' <BACKSPACE>'+#13#10+' Para voltar!', 324, 18,2, 2, Tposicao);
      Set_Window ('B');
      clrscr;
      Centraliza_Texto (#4+'HIDROAVIÃO  X5'+#13#10#13#10+' SUBMARINO   X4'+#13#10#13#10+' CRUZADOR    X3'+#13#10#13#10+' ENCOURAÇADO X2'+#13#10#13#10+' PORTA-AVIÃO X1', 270, 15, 2, 1, Tposicao);
      Estado:= 1;
      Espacamento.y:= 3;
      
      window (0,0,0,0);
      
      Desenha_Bordas (cyan, black, 240, NaviosCounterX + 1, NaviosCounterY + 21, 29, -1, true, false, false, false);
      
      Desenha_Bordas (blue, black, 219, LArenaATiroX, LArenaATiroY, 31, 15, true, true, false, false);
      Desenha_Bordas (blue, black, 219, LArenaATiroX - 1, LArenaATiroY - 1, 33, 17, false, true, false, false);
      
      
      Desenha_Bordas (cyan, black, 219, NaviosCounterX - 1, NaviosCounterY, 33, 36, true, true, false, false);
      Desenha_Bordas (cyan, black, 219, NaviosCounterX, NaviosCounterY, 31, 36, false, true, false, false);
      
      
      
      //------------------------------ STAND BY --------------------------------//
      
      ID.Posi:= 1;
      for I:= 1 to 15 do
      ID.Pool[I]:= I;
      for I:= 1 to 5 do
      ID.Quantidade[6-I]:= I;
      Estado_H:= 1;
      
      repeat
        Cursoroff;
        
        If (Estado_Alternativo = 0) OR (Estado_Alternativo <> Estado) then
        Desenha_Navio_Selecao (Estado, 0, 0);
        
        Estado_Alternativo:= Estado;
        Set_Window ('B');
        Key:= (readkey);
        case (key) of
          #0: Mover_Cursor_Navios (Estado, Q_EstadoN, Tposicao, Espacamento, true, Estado);
          #13: begin     
            Set_Window ('D');
            Posicionar_Navios (Estado, INICIA);
            If INICIA = ('Y') then
            exit;   // começa jogo
          end;
          #8:  begin    
            gotoxy (Tposicao.x, Tposicao.y + ((Estado-1)*Espacamento.y));
            write (' ');
            Set_Window ('A');
            clrscr; textcolor(lightgray);
            Centraliza_Texto (' Deseja Sair?', 324, 18, 1, 3, Tposicao);
            Centraliza_Texto (' SIM          NAO', 324, 18, -1, 1, Tposicao);
            gotoxy (tposicao.x,tposicao.y); write (#4);
            Espacamento.x := 13; Espacamento.y := 0;
            repeat
              Key:= (readkey);
              case (key) of
                #0: Mover_Cursor_Navios (Estado_H, 2, Tposicao, Espacamento, false, Estado_H);
              end;
            until (Key = #13) OR (Key = #8);
            If (Estado_H = 1) OR (Key = #8) then begin
              window (0,0,0,0); clrscr;
              SAIR:= TRUE;
              Exit;
            end
            else begin
              clrscr; textcolor(lightgray);
              Estado:=1;
              Estado_H:=1;
              Centraliza_Texto ('SELECIONE os'+#13#10+' Navios desejados!' +#13#10+ ' <ENTER>'+#13#10+' Para posicionar!' +#13#10#13#10+ ' <SPACEBAR>'+#13#10+' Para rotacionar!' +#13#10#13#10+ ' <DELETE>'+#13#10+' Para remover!' +#13#10#13#10+ ' <BACKSPACE>'+#13#10+' Para voltar!', 324, 18,2, 2, Tposicao);
              Set_Window ('B');
              Espacamento.y:= 3; Tposicao.x:= 1; Tposicao.y:= 4;
              gotoxy (Tposicao.x, Tposicao.y); Write (#4);
            end;
          end;
        end;
        
      until (false);
      
    end;
    
    
    //----------------------------------- // FIM Procedure 6 //----------------------------------------------------------------------- //
    
    
    //----------------------------------- // Procedure 7 //----------------------------------------------------------------------- //
    
    
    Procedure GArena_Axel (Var Arena_Axel : Matriz);
    
    // Procedure GArena_Axel é utilizada para gerar os navios na Arena do Axel (Axel é o nome que dei ao oponente Bot! :) )
    
    var
    
    Posicao: XY;
    Estado, PoolP, I, MAXJ, J, CoordenadaX, CoordenadaY, ID: integer; 
    Posicao_Valida: boolean;
    Pool: array [1..5] of integer = (5, 4, 3, 2, 1);
    Fix: array [1..11, 1..5] of XY;
    
    begin
      
      Fix[1][1].x:= -1; Fix[1][2].x:= 0; Fix[1][3].x:= 1;        //.*.
      Fix[6][1].x:= 0; Fix[6][2].x:= 0; Fix[6][3].x:= 1;         //:.
      Fix[7][1].x:= -1; Fix[7][2].x:= 0; Fix[7][3].x:= 1;        //*.*
      Fix[8][1].x:= -1; Fix[8][2].x:= 0; Fix[8][3].x:= 0;        //.:
      Fix[3][1].x:= 0; Fix[3][2].x:= 1;                          // .. H
      Fix[4][1].x:= -1; Fix[4][2].x:= 0; Fix[4][3].x:= 1; Fix[4][4].x:= 2;     //.... H
      Fix[5][1].x:= -2; Fix[5][2].x:= -1; Fix[5][3].x:= 0; Fix[5][4].x:= 1; Fix[5][5].x:= 2;   //..... H
      Fix[1][1].y:= 0 ; Fix[1][2].y:= -1; Fix[1][3].y:= 0;       //.*.
      Fix[6][1].y:= -1; Fix[6][2].y:= 1; Fix[6][3].y:= 0;        //:.
      Fix[7][1].y:= 0; Fix[7][2].y:= 1; Fix[7][3].y:= 0;         //*.*
      Fix[8][1].y:= 0; Fix[8][2].y:= -1; Fix[8][3].y:= 1;        //.:
      Fix[9][1].y:= 0; Fix[9][2].y:= 1;                          // .. V
      Fix[10][1].y:= -1; Fix[10][2].y:= 0; Fix[10][3].y:= +1; Fix[10][4].y:= +2;        //.... V
      Fix[11][1].y:= -2; Fix[11][2].y:= -1; Fix[11][3].y:= 0; Fix[11][4].y:= +1; Fix[11][5].y:= +2;  //..... V
      
      ID:=1;
      
      for I:=1 to 15 do begin
        repeat
          Estado:= Random (11)+1;
          case (Estado)of
            1, 6, 7, 8: begin PoolP:= 1; MAXJ:= 3;
            end;
            2: begin PoolP:= 2; MAXJ:= 1;
            end;
            3, 9: begin PoolP:= 3; MAXJ:= 2;
            end;
            4, 10: begin PoolP:= 4; MAXJ:= 4;
            end;
            5, 11: begin PoolP:= 5; MAXJ:= 5;
            end;
          end;
        until Pool[PoolP] <> 0;
        
        Dec(Pool[PoolP]);
        
        repeat
          repeat
            Posicao_Valida:= TRUE;
            posicao.x:= Random (15)+1;
            posicao.y:= Random (15)+1;
            case (Estado) of
              1: If (Posicao.x < 2) OR (Posicao.x > 14) OR (Posicao.y <2) OR (Posicao.y > 15) then Posicao_Valida:= FALSE;    // triangulo
              2: If (Posicao.x < 1) OR (Posicao.x > 15) OR (Posicao.y <1) OR (Posicao.y > 15) then Posicao_Valida:= FALSE;    // 1 bloco
              3: If (Posicao.x < 1) OR (Posicao.x > 14) OR (Posicao.y <1) OR (Posicao.y > 15) then Posicao_Valida:= FALSE;    // 2 blocos H
              4: If (Posicao.x < 2) OR (Posicao.x > 13) OR (Posicao.y <1) OR (Posicao.y > 15) then Posicao_Valida:= FALSE;    // 4 blocos H
              5: If (Posicao.x < 3) OR (Posicao.x > 13) OR (Posicao.y <1) OR (Posicao.y > 15) then Posicao_Valida:= FALSE;    // 5 blocos H
              6: If (Posicao.x < 1) OR (Posicao.x > 14) OR (Posicao.y <2) OR (Posicao.y > 14) then Posicao_Valida:= FALSE;    // triangulo topo para direita    :.
              7: If (Posicao.x < 2) OR (Posicao.x > 14) OR (Posicao.y <1) OR (Posicao.y > 14) then Posicao_Valida:= FALSE;    // triangulo topo para baixo      *.*
              8: If (Posicao.x < 2) OR (Posicao.x > 15) OR (Posicao.y <2) OR (Posicao.y > 14) then Posicao_Valida:= FALSE;    // triangulo topo para esquerda  .:
              9: If (Posicao.x < 1) OR (Posicao.x > 15) OR (Posicao.y <1) OR (Posicao.y > 14) then Posicao_Valida:= FALSE;    // 2 blocos V
              10: If (Posicao.x < 1) OR (Posicao.x > 15) OR (Posicao.y <2) OR (Posicao.y > 13) then Posicao_Valida:= FALSE;   // 4 blocos V
              11: If (Posicao.x < 1) OR (Posicao.x > 15) OR (Posicao.y <3) OR (Posicao.y > 13) then Posicao_Valida:= FALSE;   // 5 blocos V
            end;
          until Posicao_Valida = TRUE;
          
          J:=1;
          repeat
            CoordenadaX:= posicao.x + Fix[Estado][J].x;
            CoordenadaY:= posicao.y + Fix[Estado][J].y;
            
            If (Arena_AXEL [CoordenadaX, CoordenadaY].estado <> 0) then begin
              Posicao_Valida:= FALSE;
              break;
            end;
            Inc(J);
          until J=MAXJ+1;
          
        until Posicao_Valida = TRUE;
        
        J:=1;
        repeat
          CoordenadaX:= posicao.x + Fix[Estado][J].x;
          CoordenadaY:= posicao.y + Fix[Estado][J].y;
          Arena_Axel[CoordenadaX, CoordenadaY].Estado:= Estado;
          Arena_Axel[CoordenadaX, CoordenadaY].ID:= ID;
          Inc(J);
          
        until J=MAXJ+1;
        
        inc (ID);
        
      end;
    end;
    
    
    //----------------------------------- // FIM Procedure 7 //----------------------------------------------------------------------- //
    
    
    //----------------------------------- // Procedure 8 //----------------------------------------------------------------------- //
    
    
    Procedure Set_Window_Partida (Tipo: Char);
    
    // Procedure Set_Window_Partida, assim como Set_Window, gera windows específicas que são utilizadas durante a execução do jogo principal
    // Um pouco redundante se me pergunte... teria feito apenas uma dessas se pudesse voltar no tempo, haha
    
    const
    
    POSICAO_HORIZONTAL = 12;
    POSICAO_VERTICAL = 5;
    DIMENSAO_HORIZONTAL = 59;
    DIMENSAO_VERTICAL = 29;
    
    begin
      case (Tipo) of
        'A': Window	(StatusScreenX, StatusScreenY +34 +1, StatusScreenX +1 +(18-1), StatusScreenY +36 +1 +(18-1));  
        'B': Window	(StatusScreenX +18 +1 +1, StatusScreenY +34 +1, StatusScreenX +20 +1 +1 +(18-1), StatusScreenY +36 +1 +(18-1)); 
        'C': Window (StatusScreenX +38 +2 +1, StatusScreenY +34 +1, StatusScreenX +41 +2 +1 +(15-1), StatusScreenY +41);
        'D': Window (POSICAO_HORIZONTAL, POSICAO_VERTICAL, POSICAO_HORIZONTAL+DIMENSAO_HORIZONTAL-1, POSICAO_VERTICAL+DIMENSAO_VERTICAL-1);
        'E': window (trunc(POSICAO_HORIZONTAL+1/3*DIMENSAO_HORIZONTAL-1), trunc(POSICAO_VERTICAl+1/3*DIMENSAO_VERTICAL-2), trunc(POSICAO_HORIZONTAL+2/3*DIMENSAO_HORIZONTAL-1),trunc(POSICAO_VERTICAl+2/3*DIMENSAO_VERTICAL-1));
        'F': window (LArenaATiroX, LArenaATiroY, LArenaATiroX + 30, LArenaATiroY + 14);  
        'G': window (StatusScreenX +41, StatusScreenY +43, StatusScreenX + 58, StatusScreenY + 54);
      end;
    end;
    
    //----------------------------------- // FIM Procedure 8 //----------------------------------------------------------------------- //
    
    
    //----------------------------------- // Procedure 9 //----------------------------------------------------------------------- //
    
    
    Procedure Escreve_Mensagem (Mensagem : string; Janela : char; AjusteY : integer);
    
    // Procedure Escreve_Mensagem é uma outra procedure para auxiliar na centralização de textos e escrever mensagens em determinadas janelas
    
    Var
    QColunas, QLinhas, Tamanho, LinhasM, PosicaoX, PosicaoY : integer;
    
    begin
      
      case (Janela) of
        
      'A': begin Qlinhas:= 20; Qcolunas:= 18; end;
      'B': begin Qlinhas:= 20; Qcolunas:= 20; end;
      'C': begin Qlinhas:= 20; Qcolunas:= 18; end;
      'E': begin Qlinhas:= 10; Qcolunas:= 19; end;
        
      end;
      Set_Window_Partida (Janela);
      
      Tamanho:= length(Mensagem);
      If Tamanho <= Qcolunas then begin
        LinhasM:= 1;
        PosicaoX:= trunc((Qcolunas - Tamanho)/2)+1;
        If ODD (Qcolunas - Tamanho) then PosicaoX:= PosicaoX+1;
      end
      
      else begin
        PosicaoX:=1;
        if Frac (Tamanho/Qcolunas) <> 0 then
        LinhasM:= trunc(Tamanho/Qcolunas)+1
        else
        LinhasM:= trunc(Tamanho/Qcolunas);
      end;
      PosicaoY:= trunc((Qlinhas - LinhasM)/2)+1;
      
      PosicaoY:= PosicaoY+AjusteY;
      
      gotoxy (PosicaoX, PosicaoY);
      write (Mensagem);
      
      window (0,0,0,0);
      
    end;
    
    
    //----------------------------------- // FIM Procedure 9 //----------------------------------------------------------------------- //
    
    Procedure Finaliza_Jogo (Vitoria: Boolean); FORWARD;  		// declaração antecipada de uma procedure ainda por vir
    
    //----------------------------------- // Procedure 10 //----------------------------------------------------------------------- //
    
    Procedure Inicia_Partida (Arena : Matriz);
    
    // Procedure Inicia_Partida controla e executa todas as sub-procedures responsáveis pelo começo, meio e fim do jogo
    
    const
    
    DIMENSAO_HORIZONTAL = 59;
    DIMENSAO_VERTICAL = 29;
    AREA_ARENA = DIMENSAO_HORIZONTAL*DIMENSAO_VERTICAL;
    
    Var
    
    Icone: array [1..12] of char = (#4, #254, #5, #6, #3, #4, #4, #4, #5, #6, #3, 'X');
    I, J, T, num, Tiro_Counter, ACC, Totalshots, Aquashots, Navioshots, NaviosDeadbyJogador, NaviosDeadbyAxel: integer;
    Letra, Key: char;
    Letter: array [1..15] of char = ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O');
    Vitima, VitimaAxel: array [1..15] of Life;
    Posicao, Tposicao, PosicaoC, PosicaoC_Antiga: XY;
    Fix: array [1..11, 1..5] of XY;
    Arena_Axel, Arena_Tiro, Arena_Axel_Tiro: Matriz;
    Movimento_Valido, TurnoJogador: Boolean;
    MensagemA: String = ('ÁGUA!');
    MensagemB: String = ('ATINGIDO!');
    MensagemC: String = ('--!AFUNDADO!--');
    NAVIO_Name: array [1..12] of String = ('HIDROAVIÃO', 'SUBMARINO!', 'CRUZADOR', 'ENCOURAÇADO!', 'PORTA-AVIÃO!', 'HIDROAVIÃO', 'HIDROAVIÃO', 'HIDROAVIÃO', 'CRUZADOR', 'ENCOURAÇADO!', 'PORTA-AVIÃO!', 'ÁGUA');
    TopMessage, BotMessage: String;
    Pisca: array [1..3] of Blink;
    Contador: array [1..5] of Frota;
    Combo: Combosa;
    TirosAgua: Integer;
    TOTALAISHOTS: Integer;
    
    
    // variaveis utilizadas em Axel_Joga
    
    
    
    Tiro_Axel: XY;
    PosicaoRelevante: Array [1..16] of Informayshon;
    PR_I : Integer;
    K, W: XY;
    RandomList: Array [1..4] of Integer;
    Tiro_Valido, Tiro_Navio: Boolean;
    ADD: String = ('ADD');
    REMOVE: String = ('REMOVE');
    R, RLS, Rref : integer;
    
    TESTE: integer;				// variavel apenas para debugging
    
    //----------------------------------- // Sub-Procedure 10-1 //----------------------------------------------------------------------- //
    
    
    Procedure Axel_Joga (Aleatorio, AI: Boolean; Var Tiro_Axel: XY);
    
    // Procedure Axel_Joga é responsável por todas as ações do inimigo! (vulgo Axel Bot)
    
    Var
    
    I: integer; 		
    DParameter: Integer;
    
    
    
    // Teremos 4 arenas, arena (navios do jogador) arena_tiro (com os tiros do jogador), arena_axel (navios do axel) e arena_axel_tiro (com os tiros do axel)
    
    
    //----------------------------------- // Sub-Procedure 10-1-1 //----------------------------------------------------------------------- //
    
    
    Procedure Manipula_Caso_Extra (Triangulo, Linha: Boolean; M: Integer);
    
    // Procedure Manipula_Caso_Extra faz a resolução de certas situações extras que podem acontecer
    // Por exemplo, encontrar por "acidente" várias partes de um outro navio enquanto o bot ainda estava trabalhando no primeiro navio que ele encontrou
    
    Var
    
    A, B, C: Integer = 0;
    
    begin
      
      
      
      A:= PosicaoRelevante[M].Posicao.x - K.x;
      B:= PosicaoRelevante[M].Posicao.y - K.y;
      
      If Triangulo then begin
        
        If (A = 0) OR (B = 0) then begin
          
          // Letra indica aonde QUERO BANIR: beloW, Up, Right ou Left
          If A = 0 then begin
            if B > 0 then PosicaoRelevante[M].Direcao_Extra:= ('W');
            if B < 0 then PosicaoRelevante[M].Direcao_Extra:= ('U');
          end;
          
          If B = 0 then begin
            if A > 0 then PosicaoRelevante[M].Direcao_Extra:= ('R');
            if A < 0 then PosicaoRelevante[M].Direcao_Extra:= ('L');
          end;
          
        end
        
        else begin
          
          If ((A < 0) AND (B < 0)) OR ((A > 0) AND( B > 0)) then
          PosicaoRelevante[M].Direcao_Extra:= ('E')               //  "\" esquerda
          else PosicaoRelevante[M].Direcao_Extra:= ('D');         //  "/" direita
          
          C:= PosicaoRelevante[M].Posicao.y - K.y;
          
          If C < 0 then begin
            
            PosicaoRelevante[M].Extra.x:= PosicaoRelevante[M].Posicao.x;
            PosicaoRelevante[M].Extra.y:= PosicaoRelevante[M].Posicao.y;
            PosicaoRelevante[M].Posicao.x:= K.x;
            PosicaoRelevante[M].Posicao.y:= K.y;
            
          end;
          
          
        end;
      end;
      
      If Linha then begin
        
        If A = 0 then
        PosicaoRelevante[M].Direcao_Extra:= ('V')
        
        else
        PosicaoRelevante[M].Direcao_Extra:= ('H');
        
        
      end;
      
    end;
    
    //----------------------------------- // FIM Sub-Procedure 10-1-1 //----------------------------------------------------------------------- //
    
    
    //----------------------------------- // Sub-Procedure 10-1-2 //----------------------------------------------------------------------- //
    
    
    Procedure Set_PosicaoRelevante (Input: String);
    
    // Procedure Set_PosicaoRelevante é responsável por guardar e utilizar a informação de todos os navios que o Bot conseguiu localizar
    
    Var
    
    A, Z: Integer = 1;
    check: Boolean = FALSE;   //variável para Debugging
    ADD, REMOVE, Repetido: Boolean = FALSE;
    
    begin
      
      
      If Arena [K.x, K.y].Estado = 2 then exit;
      If Input = 'ADD' then ADD:= TRUE
      else If Input = 'REMOVE' then REMOVE:= TRUE
      else exit;
      
      If ADD then begin                                              			 // Se adicionar
        
        
        while PosicaoRelevante[A].Estado <> 0 do begin                     // enquanto tem estado naquela posição relevante...
          
          if Arena_Axel_Tiro[K.x, K.y].ID <> PosicaoRelevante[A].ID then   // Buscando se o ID do navio encontrado já está numa posição relevante (REPETIDO)
          
          inc (A)
          
          else begin
            Repetido:= TRUE;                                            	 // se encontrar bota, a flag
            break
          end
        end;
        
        If Repetido then begin
          
          Inc (PosicaoRelevante[A].Continua);
          
          If PosicaoRelevante[A].Continua >= 3 then exit;
          
          case PosicaoRelevante[A].Estado of
            
            1, 6, 7, 8: begin
              
              If A = 1 then begin
                for I:= 1 to 4 do RandomList[I]:= I;
                RLS:= 4;
              end;
              
              Manipula_Caso_Extra (true, false, A);
              
            end;
            
            4, 10, 5, 11: Manipula_Caso_Extra (false, true, A);
            
          end;
          
        end
        
        else begin                                                       		 // se nao for repetido
          
          Inc(PR_I);
          
          
          PosicaoRelevante[PR_I].Estado:= Arena[K.x, K.y].Estado;                   // Marca posição Relevante
          PosicaoRelevante[PR_I].Posicao.x:= K.x;
          PosicaoRelevante[PR_I].Posicao.y:= K.y;
          PosicaoRelevante[PR_I].ID:= Arena[K.x, K.y].ID;
          PosicaoRelevante[PR_I].Continua:= 1;
          
          
          Case (Arena_Axel_Tiro[K.x, K.y].Estado) of
            
            1, 6, 7, 8: PosicaoRelevante[PR_I].MaxContinua:= 3;
            3, 9: PosicaoRelevante[PR_I].MaxContinua:= 2;
            4, 10: PosicaoRelevante[PR_I].MaxContinua:= 4;
            5, 11: PosicaoRelevante[PR_I].MaxContinua:= 5;
            
            
          end;
          
          If (PR_I >= 1) AND (PosicaoRelevante[1].Estado = 0) then       // mais variáveis para debugging
          Check:= TRUE;
          
          
        end;
        
      end;
      
      If REMOVE then begin                                         // Se remover
        
        If PosicaoRelevante[2].Estado = 0 then begin               // Checa se há mais de uma posição relevante
          PosicaoRelevante[1].Estado:= 0;
          PosicaoRelevante[1].Posicao.x:= 0;
          PosicaoRelevante[1].Posicao.y:= 0;
          PosicaoRelevante[1].ID:= 0;
          PosicaoRelevante[1].Continua:= 0;
          PosicaoRelevante[1].MaxContinua:= 0;
          PosicaoRelevante[1].Direcao_Extra:= ' ';
          PosicaoRelevante[1].Extra.x:= 0;
          PosicaoRelevante[1].Extra.y:= 0;
          
        end
        else begin
          
          Z:=1;
          
          Repeat
            
            PosicaoRelevante[Z].Estado:= PosicaoRelevante[Z+1].Estado;
            PosicaoRelevante[Z].Posicao:= PosicaoRelevante[Z+1].Posicao;
            PosicaoRelevante[Z].ID:= PosicaoRelevante[Z+1].ID;
            PosicaoRelevante[Z].Continua:= PosicaoRelevante[Z+1].Continua;
            PosicaoRelevante[Z].MaxContinua:= PosicaoRelevante[Z+1].MaxContinua;
            PosicaoRelevante[Z].Direcao_Extra:= PosicaoRelevante[Z+1].Direcao_Extra;
            PosicaoRelevante[Z].Extra:= PosicaoRelevante[Z+1].Extra;
            
            inc(Z);
            
          Until PosicaoRelevante[Z].Estado = 0;
          
        end;
        
        Dec(PR_I);
        
        
        If (PR_I >= 1) AND (PosicaoRelevante[1].Estado = 0) then
        Check:= TRUE;
        
        
        
        for I:= 1 to 4 do RandomList[I]:= I;
        RLS:= 4;
        
      end;
    end;
    
    //----------------------------------- // FIM Sub-Procedure 10-1-2 //----------------------------------------------------------------------- //
    
    
    //----------------------------------- // Sub-Procedure 10-1-3 //----------------------------------------------------------------------- //
    
    Procedure BAN (Input: Integer);
    
    // Procedure BAN é responsável por Banir certas coordenadas que já foram exploradas pelo Bot, ou que por exclusão não possuem um navio
    
    var
    
    B: integer = (1);
    
    Begin
      
      
      While RandomList[B] <> Input do begin
        
        If B = 4 then exit
        else inc(B);
        
      end;
      
      while (B < 4) do begin
        RandomList[B]:= RandomList[B+1];
        inc(B);
      end;
      
      RandomList[B]:= 0;
      
      Dec (RLS);
      
    end;
    
    //----------------------------------- // FIM Sub-Procedure 10-1-3 //----------------------------------------------------------------------- //
    
    
    //----------------------------------- // Sub-Procedure 10-1-4 //----------------------------------------------------------------------- //
    
    
    Procedure Valida_Tiro;
    
    // Procedure Valida_Tiro é responsável por garantir que o Bot não atire em lugares impossíveis, como  por exemplo para fora da arena
    
    
    Begin
      
      Tiro_Valido:= TRUE;
      Tiro_Navio:= FALSE;
      
      If (K.x > 15) OR (K.y > 15) OR (K.x <=0) OR (K.y <= 0) then begin             // SE OOB, invalido
        Tiro_Valido:= FALSE;
        exit;
      end;
      
      case Arena_Axel_Tiro[K.x, K.y].Estado of
        
        1..11: begin
          
          If PosicaoRelevante[1].ID = Arena_Axel_Tiro[K.x, K.y].ID then
          Tiro_Navio:= TRUE
          
          else Tiro_Valido:= FALSE;
          
        end;
        
        12: Tiro_Valido:= FALSE;
        
      end;
      
      If (Tiro_Valido = TRUE) AND (Tiro_Navio = FALSE) then inc (TOTALAISHOTS);
      
    end;
    
    
    //----------------------------------- // FIM Sub-Procedure 10-1-4 //----------------------------------------------------------------------- //
    
    
    //----------------------------------- // Axel_Joga - Sub-Procedure 10-1 - START //----------------------------------------------------------------------- //
    
    
    Begin
      
      
      
      Case Difficulty of
        
        'E': DParameter:= 225;
        'N': Dparameter:= 36;
        'H': Dparameter:= 15;
        
      end;
      
      
      while (PosicaoRelevante[1].Continua= PosicaoRelevante[1].MaxContinua) AND (PosicaoRelevante[1].Continua <> 0) do
      Set_PosicaoRelevante (REMOVE);
      
      
      If Aleatorio then begin
        
        // Esse trecho "Aleatório" foi utilizado apenas para testes no começo da criação do Bot, enquanto testava tiros completamente aleatórios.
        // Com o programa completo, esse trecho nunca é chamado
        
        
        Repeat
          
          R:= Random (15) +1;
          Tiro_Axel.x:= R;
          
          R:= Random (15) +1;
          Tiro_Axel.y:= R;
          
          K:= Tiro_Axel;
          
          Valida_Tiro;
          
          if (Tiro_Navio = FALSE) AND (Tiro_Valido = TRUE) then begin
            
            If Arena[K.x, K.y].Estado = 0 then Arena_Axel_Tiro[K.x, K.y].Estado:=12 else begin
              
              Arena_Axel_Tiro[K.x, K.y].Estado:= Arena[K.x, K.y].Estado;
              Arena_Axel_Tiro[K.x, K.y].ID:= Arena[K.x, K.y].ID;
              
            end;
            
            break;
            
          end;
          
        Until (false)
        
      end
      
      else begin
        
        
        If PosicaoRelevante[1].Estado = 0 then begin					// se nenhuma posição relevante, tiro aleatório
          
          
          for I:= 1 to 4 do RandomList[I]:= I;
          RLS:= 4;
          
          Repeat
            
            If TESTE = 0 then begin K.x:= 14; K.y:= 15       // Mais testes e debugging
            end
            else begin
              
              K.x:= random(15) +1;
              K.y:= random(15) +1;
              
            end;
            
            
            If TirosAgua = DParameter then begin      			// Basicamente o controle de dificuldade do Bot
              TirosAgua:= 0;                               	// Não conte para ninguém, mas o Axel_Bot cheata um pouco quando ele erra demais
              For I:=1 to 15 do begin
                for J:=1 to 15 do begin
                  If (Arena[I, J].Estado <> 0) AND (Arena_Axel_Tiro[I, J].Estado = 0) then begin
                    K.x:= I;
                    K.y:= J;
                    break;
                  end;
                end;
                If (Arena[I, J].Estado <> 0) AND (Arena_Axel_Tiro[I, J].Estado = 0) then break;
              end;
              
            end;
            
            
            
            Valida_Tiro;
            
            if (Tiro_Navio = FALSE) AND (Tiro_Valido = TRUE) then begin
              
              If Arena[K.x, K.y].Estado = 0 then begin
                Arena_Axel_Tiro[K.x, K.y].Estado:= 12;
                inc (TirosAgua);
              end
              
              else begin
                
                Arena_Axel_Tiro[K.x, K.y].Estado:= Arena[K.x, K.y].Estado;
                Arena_Axel_Tiro[K.x, K.y].ID:= Arena[K.x, K.y].ID;
                TirosAgua:= 0;
                Set_PosicaoRelevante (ADD);
                
              end;
              
              inc (TESTE);
              break;
              
            end;
            
          until (false);
        end
        
        else begin  // Se tem posição relevante....
          
          
          Repeat
            
            
            Case PosicaoRelevante[1].Direcao_Extra of
              
            ('V'): begin BAN (1); BAN (2); PosicaoRelevante[1].Direcao_Extra:= ' '; end;   	// Vertical
            ('H'): begin BAN (3); BAN (4); PosicaoRelevante[1].Direcao_Extra:= ' '; end;  	// Horizontal
              
            ('W'): begin BAN (2); BAN (4); end; 	// beloW
            ('U'): begin BAN (1); BAN (3); PosicaoRelevante[1].Direcao_Extra:= 'Z'; end;   // Up
            ('R'): begin BAN (1); BAN (4); PosicaoRelevante[1].Direcao_Extra:= 'Z';end;    // Right
            ('L'): begin BAN (2); BAN (3); PosicaoRelevante[1].Direcao_Extra:= 'Z';end;    // Left
              
            end;
            
            
            
            Rref:= Random(RLS) + 1;                      				// gera um número aleatório baseado no tamanho da Random List (RLS -> Random List Size)
            R:= RandomList[Rref];                               // pega o número da RLS daquela posição e joga em R (esse é o valor que queremos em R)
            
            
            Case (PosicaoRelevante[1].Estado) of
              
              1, 6, 7, 8: begin
                
                
                If (PosicaoRelevante[1].Continua = 1) OR (PosicaoRelevante[1].Direcao_Extra = 'Z') then begin
                  
                  Case (R) of
                    
                  1: begin W.x:= 1;				W.y:= -1 ; end;         	//NE
                  2: begin W.x:= -1;			W.y:= 1; end; 	          //SW
                  3: begin W.x:= -1;			W.y:= -1; end;            //NW
                  4: begin W.x:= 1;				W.y:= 1; end;             //SE
                    
                  end;
                end;
                
                If PosicaoRelevante[1].Continua = 2 then begin
                  
                  if PosicaoRelevante[1].Direcao_Extra = ('D') then begin     // "/"
                    
                    Case (R) of
                      
                    1: begin W.x:= 1;				W.y:= 1 ; end;
                    2: begin W.x:= -1;			W.y:= -1; end;
                    3: begin W.x:= 2;				W.y:= 0; end;
                    4: begin W.x:= 0;				W.y:= -2; end;
                      
                    end;
                  end;
                  
                  if  PosicaoRelevante[1].Direcao_Extra = ('E') then begin 		// "\"
                    
                    Case (R) of
                      
                    1: begin W.x:= -1;				W.y:= 1 ; end;
                    2: begin W.x:= 1;					W.y:= -1; end;
                    3: begin W.x:= -2;				W.y:= 0; end;
                    4: begin W.x:= 0;					W.y:= -2; end;
                      
                    end;
                  end;
                end;
              end;
              
              
              3, 4, 5, 9, 10, 11: begin
                
                Case (R) of
                  
                1: begin W.x:= 1;				W.y:= 0; end;         		//D
                2: begin W.x:= -1;			W.y:= 0; end; 	          //E
                3: begin W.x:= 0;				W.y:= -1; end;            //C
                4: begin W.x:= 0;				W.y:= 1; end;             //B
                  
                end;
              end;
            end;
            
            K.x:= PosicaoRelevante[1].Posicao.x+W.x;
            K.y:= PosicaoRelevante[1].Posicao.y+W.y;
            
            Valida_Tiro;
            
            If Tiro_Valido = FALSE then BAN (R);
            
          until Tiro_Valido = TRUE;
          
          //---------------------------------------------------------------- // FOGO!!!! // -------------------------------------------------------------------------------
          
          Case Arena[K.x, K.y].estado of
            
            0: begin             // agua
              Arena_Axel_Tiro[K.x, K.y].Estado:= 12;
              BAN (R);
              inc (TirosAgua);
            end;
            
            1..11: begin         // navio
              
              TirosAgua:= 0;
              
              If NOT ((PosicaoRelevante[1].Continua >=2) AND NOT ((Arena[K.x, K.y].estado = 1) OR (Arena[K.x, K.y].estado = 6) OR (Arena[K.x, K.y].estado = 7) OR (Arena[K.x, K.y].estado = 8))) then
              
              begin
                
                Arena_Axel_Tiro[K.x, K.y].Estado:= Arena[K.x, K.y].Estado;
                Arena_Axel_Tiro[K.x, K.y].ID:= Arena[K.x, K.y].ID;
                Set_PosicaoRelevante (ADD);
                If Arena_Axel_Tiro[K.x, K.y].ID <> PosicaoRelevante[1].ID then BAN (R);
                
              end
              
              else begin
                
                If Arena_Axel_Tiro[K.x, K.y].ID = PosicaoRelevante[1].ID then begin
                  
                  repeat
                    
                    case (R) of
                      1: inc (K.x);
                      2: dec (K.x);
                      3: dec (K.y);
                      4: inc (K.y);
                    end;
                    
                    Valida_Tiro;
                    
                    If Tiro_Valido = FALSE then begin
                      BAN (R);
                      break;
                      
                    end;
                    
                  until Arena_Axel_Tiro[K.x, K.y].ID <> PosicaoRelevante[1].ID;
                  
                  If Tiro_Valido = FALSE then begin
                    Tiro_Valido:= TRUE;
                    repeat
                      case (R) of
                        1: dec (K.x);
                        2: inc (K.x);
                        3: inc (K.y);
                        4: dec (K.y);
                      end;
                      
                    until Arena_Axel_Tiro[K.x, K.y].ID <> PosicaoRelevante[1].ID
                    
                  end;
                  
                  If Arena[K.x, K.y].ID = 0 then begin
                    Arena_Axel_Tiro[K.x, K.y].Estado:= 12;
                    BAN (R);
                  end
                  
                  else begin
                    
                    If Arena[K.x, K.y].ID = PosicaoRelevante[1].ID 	then begin
                      Arena_Axel_Tiro[K.x, K.y].Estado:= Arena[K.x, K.y].Estado;
                      Arena_Axel_Tiro[K.x, K.y].ID:= Arena[K.x, K.y].ID;
                      inc (PosicaoRelevante[1].Continua);
                    end;
                    
                    If Arena[K.x, K.y].ID <> PosicaoRelevante[1].ID then begin
                      Arena_Axel_Tiro[K.x, K.y].Estado:= Arena[K.x, K.y].Estado;
                      Arena_Axel_Tiro[K.x, K.y].ID:= Arena[K.x, K.y].ID;
                      BAN (R);
                      Set_PosicaoRelevante (ADD);
                      
                    end;
                  end;
                end
                
                else begin
                  
                  If Arena[K.x, K.y].ID = PosicaoRelevante[1].ID then begin
                    Arena_Axel_Tiro[K.x, K.y].Estado:= Arena[K.x, K.y].Estado;
                    Arena_Axel_Tiro[K.x, K.y].ID:= Arena[K.x, K.y].ID;
                    Inc(PosicaoRelevante[1].Continua);
                    
                  end
                  
                  else begin
                    Arena_Axel_Tiro[K.x, K.y].Estado:= Arena[K.x, K.y].Estado;
                    Arena_Axel_Tiro[K.x, K.y].ID:= Arena[K.x, K.y].ID;
                    Set_PosicaoRelevante (ADD);
                    BAN (R);
                    
                    
                  end;
                  
                end;
                
              end;
              
            end;
            
          end;
          
        end;
        
        If (PosicaoRelevante[1].MaxContinua <> 0) AND (PosicaoRelevante[1].MaxContinua = PosicaoRelevante[1].Continua) then
        Set_PosicaoRelevante (REMOVE);
        
        Tiro_Axel.x:= K.x;
        Tiro_Axel.y:= K.y;
        
      end;
      
    end;
    
    
    
    //----------------------------------- // FIM Sub - Procedure 10-1 //----------------------------------------------------------------------- //
    
    
    //----------------------------------- // Sub - Procedure 10-2 //----------------------------------------------------------------------- //
    
    Procedure Desenha_Navio_Atingido (Estado, FX, FY: integer);
    
    
    // Procedure Desenha_Navios_Atingidos é responsável por desenhar uma representação dos navios que foram atingidos. Ta-Da!
    
    
    Var
    Color: Byte;
    
    begin
      
      
      If Vitima[Arena_Tiro[PosicaoC.x, PosicaoC.y].ID].Dead = TRUE then Color:= Red else Color := yellow;
      
      Set_Window_Partida ('G');
      clrscr;
      case (Estado) of
        //------------- HIDROAVIAO
        1, 6, 7, 8: begin
          Desenha_Bordas (Color, black, 4, FX-3, FY+2, 2, 2, true, true, false, false);
          Desenha_Bordas (Color, black, 4, FX+3, FY+2, 2, 2, true, true, false, false);
          Desenha_Bordas (Color, black, 4, FX, FY-2, 2, 2, true, true, false, false);
        end;
        //------------- SUBMARINO
        2: Desenha_Bordas (Color, black, 4, FX, FY, 2, 2, true, true, false, false);
        //------------- CRUZADOR
        3, 9: begin
          Desenha_Bordas (Color, black, 4, FX-2, FY, 2, 2, true, true, false, false);
          Desenha_Bordas (Color, black, 4, FX+2, FY, 2, 2, true, true, false, false);
        end;
        //------------- ENCOURAÇADO
        4, 10: begin
          Desenha_Bordas (Color, black, 4, FX-6, FY, 2, 2, true, true, false, false);
          Desenha_Bordas (Color, black, 4, FX-2, FY, 2, 2, true, true, false, false);
          Desenha_Bordas (Color, black, 4, FX+6, FY, 2, 2, true, true, false, false);
          Desenha_Bordas (Color, black, 4, FX+2, FY, 2, 2, true, true, false, false);
        end;
        //------------- PORTA AVIAO
        5, 11: begin
          Desenha_Bordas (Color, black, 4, FX-6, FY, 2, 2, true, true, false, false);
          Desenha_Bordas (Color, black, 4, FX-3, FY, 2, 2, true, false, false, false);
          Desenha_Bordas (Color, black, 4, FX, FY, 2, 2, true, true, false, false);
          Desenha_Bordas (Color, black, 4, FX+3, FY, 2, 2, true, false, false, false);
          Desenha_Bordas (Color, black, 4, FX+6, FY, 2, 2, true, true, false, false);
        end
        else Exit;
      end;
    end;
    
    
    //----------------------------------- // FIM Sub - Procedure 10-2 //----------------------------------------------------------------------- //
    
    
    //----------------------------------- // Procedure 10-3 //----------------------------------------------------------------------- //
    
    Procedure Conta_Navios_Restantes (Input: Integer; Input2: Char);
    
    // Procedure Conta_Navios_Restantes é responsável por manter a contagem de todos os navios que afundaram e aqueles que ainda restam na arena
    // para ambos o jogador e o Bot
    
    begin
      
      If Input = 50 then begin
        textcolor (green);
        gotoxy (NavioResX -2, NavioResY -4); Write ('Navios Inimigos');
        gotoxy (NavioResX +1, NavioResY -3); Write ('Restantes');
        textcolor (brown);
        gotoxy (MNavioResX +4, MNavioResY -4); Write ('Navios Aliados');
        gotoxy (MNavioResX +7, MNavioResY -3); Write ('Restantes');
        textcolor (lightgray);
        
      end
      else If (((Contador[Input].Axel = 0) AND (INPUT2 = 'A')) OR ((Contador[Input].Player = 0) AND (Input2 = 'P'))) then textcolor (red)
      else textcolor (lightgray);
      
      
      
      window (0,0,0,0);
      
      if (Input = 50 ) OR (Input2 = 'A') then begin
        
        
        If (Input = 1) OR (Input = 50)  then begin
          gotoxy (NavioResX +2, NavioResY);	write (#4);
          gotoxy (NavioResX, NavioResY + 1);	write (#4);
          gotoxy (NavioResX +4, NavioResY +1);	write (#4);
          gotoxy (NavioResX +10, NavioResY +1); write ('X '); write (Contador[1].Axel);
        end;
        
        If (Input = 2) OR (Input = 50)  then begin
          gotoxy (NavioResX +2, NavioResY +4);	write (#254);
          gotoxy (NavioResX +10, NavioResY +4); write ('X '); write (Contador[2].Axel);
        end;
        
        If (Input = 3) OR (Input = 50)  then begin
          gotoxy (NavioResX +1, NavioResY +7);	write (#5+' '+#5);
          gotoxy (NavioResX +10, NavioResY +7); write ('X '); write (Contador[3].Axel);
        end;
        
        If (Input = 4) OR (Input = 50)  then begin
          gotoxy (NavioResX -1, NavioResY +10);	write (#6+' '+#6+' '+#6+' '+#6);
          gotoxy (NavioResX +10, NavioResY +10); write ('X '); write (Contador[4].Axel);
        end;
        
        If (Input = 5) OR (Input = 50)  then begin
          gotoxy (NavioResX -2, NavioResY +13);	write (#3+' '+#3+' '+#3+' '+#3+' '+#3);
          gotoxy (NavioResX +10, NavioResY +13); write ('X '); write (Contador[5].Axel);
        end;
        
      end;
      
      
      
      
      if (Input = 50 ) OR (Input2 = 'P') then begin
        
        If (Input = 1) OR (Input = 50)  then begin
          gotoxy (MNavioResX +2, MNavioResY);	write (#4);
          gotoxy (MNavioResX, MNavioResY +1);	write (#4);
          gotoxy (MNavioResX +4, MNavioResY +1);	write (#4);
          gotoxy (MNavioResX +1, MNavioResY +2); write ('X '); write (Contador[1].Player);
        end;
        
        If (Input = 2) OR (Input = 50)  then begin
          gotoxy (MNavioResX +2, MNavioResY +4);	write (#254);
          gotoxy (MNavioResX +1, MNavioResY +5); write ('X '); write (Contador[2].Player);
        end;
        
        If (Input = 3) OR (Input = 50)  then begin
          gotoxy (MNavioResX +19, MNavioResY +1);	write (#5+' '+#5);
          gotoxy (MNavioResX +19, MNavioResY +2); write ('X '); write (Contador[3].Player);
        end;
        
        If (Input = 4) OR (Input = 50)  then begin
          gotoxy (MNavioResX +17, MNavioResY +4);	write (#6+' '+#6+' '+#6+' '+#6);
          gotoxy (MNavioResX +19, MNavioResY +5); write ('X '); write (Contador[4].Player);
        end;
        
        If (Input = 5) OR (Input = 50)  then begin
          gotoxy (MNavioResX +7, MNavioResY +7);	write (#3+' '+#3+' '+#3+' '+#3+' '+#3);
          gotoxy (MNavioResX +10, MNavioResY +8); write ('X '); write (Contador[5].Player);
        end;
        
        
      end;
    end;
    
    //----------------------------------- // FIM Sub - Procedure 10-3 //----------------------------------------------------------------------- //
    
    
    //----------------------------------- // Sub - Procedure 10-4 //----------------------------------------------------------------------- //
    
    
    Procedure Calcula_Score;
    
    // Procedure Calcula_Score é responsável por... putz, esqueci  :(
    
    Var
    
    Ajusta: Integer;
    Ajusta_String: String;
    Testa: Real;
    
    begin
      
      
      Inc (TotalShots);
      
      if Arena_Axel[PosicaoC.x, PosicaoC.y].Estado = 0 then begin   // AGUA
        
        Inc (Aquashots);
        Score:= Score + 100;
        COMBO.Counter:= 1;
        COMBO.ID:= 0;
        
      end
      else begin
        
        Inc (Navioshots);
        If COMBO.ID = Arena_Axel[PosicaoC.x, PosicaoC.y].ID then inc(COMBO.Counter, 3)
        else begin
          COMBO.ID:= Arena_Axel[PosicaoC.x, PosicaoC.y].ID;
          COMBO.Counter:= 1;
        end;
        
        Score:= Score + 1000 * (COMBO.Counter);
        
        If Vitima[Arena_Tiro[PosicaoC.x, PosicaoC.y].ID].Dead = TRUE then begin
          
          Acc:= round ((Navioshots/TotalShots)*100);
          
          Score:= Score + (Acc*100);
          
        end;
      end;
      
      
      str (Score, Ajusta_String);
      Set_Window_Partida ('C');
      
      
      
      Ajusta:= Length (Ajusta_String);
      Testa:= (Ajusta / 2);
      Ajusta:= trunc (Ajusta / 2);
      
      If Testa > Ajusta then
      Inc (Ajusta);
      
      Ajusta:= 10 - Ajusta;
      gotoxy (Ajusta,5); Textcolor (cyan); Write (Score); Textcolor (white);
      
      
    end;
    
    
    
    // ----------------------------------- // FIM Sub - Procedure 10-4 //----------------------------------------------------------------------- //
    
    
    
    // ----------------------------------- // Inicia Partida - Procedure 10 - START //----------------------------------------------------------------------- //
    
    
    begin
      
      J:=5;
      for I:= 1 to 5 do begin
        Contador[I].Axel:= J;
        Contador[I].Player:= J;
        dec (J);
      end;
      
      
      ACC:= 100;
      
      
      window (0,0,0,0);
      
      // DESENHA ARENA DE BATALHA
      textbackground	(black);
      clrscr;
      Desenha_Bordas (cyan, black, 219, POSICAO_HORIZONTAL, POSICAO_VERTICAL, DIMENSAO_HORIZONTAL, DIMENSAO_VERTICAL, true, true, false, true);  // BORDA
      I:= 0;
      letra := ('A');
      textcolor (cyan);
      repeat
        gotoxy (POSICAO_HORIZONTAL - 4, POSICAO_VERTICAL + I);   // TAG DE LETRAS
        write	(letra,'->');
        inc (letra);
        inc (I,2);
      until letra = ('P');
      I:= 1;
      repeat
        gotoxy (POSICAO_HORIZONTAL + I, POSICAO_VERTICAL - 2);   //TAG DE NUMEROS
        inc (num);
        write (num);
        inc (I,4);
      until num = (15);
      
      
      
      Desenha_Bordas (lightgray, black, 240, StatusScreenX + 20+1+21, StatusScreenY + 35, 16, 7, true, false, false, true);      // Linha do Score
      Desenha_Bordas (lightgray, black, 219, StatusScreenX + 20, StatusScreenY + 35, 20, 20, false, true, false, true);                // Caixa no meio
      Desenha_Bordas (lightgray, black, 219, StatusScreenX, StatusScreenY + 35, DIMENSAO_HORIZONTAL, 20, true, true, false, true);    // Caixa maior
      Desenha_Bordas (lightgray, black, 240, StatusScreenX + 20+1, StatusScreenY + 35+6, 18, 3, true, false, false, true);       // LINHAS Caixa meio
      Desenha_Bordas (lightgray, black, 240, StatusScreenX + 20+1, StatusScreenY + 35+14, 18, 3, true, false, false, true);
      
      
      Garena_Axel (Arena_Axel);
      
      
      Case Difficulty of
        'E': TurnoJogador:= TRUE;
        
        'N': begin
          
          I:= Random (2);
          If I = 0 then
          TurnoJogador:= FALSE
          else TurnoJogador:= TRUE;
        end;
        
        'H': TurnoJogador:= FALSE;
      end;
      
      I:=1;
      repeat
        window (0,0,0,0);
        Desenha_Bordas (cyan, black, 176, trunc(POSICAO_HORIZONTAL+1/3*DIMENSAO_HORIZONTAL), trunc(POSICAO_VERTICAl+1/3*DIMENSAO_VERTICAL), trunc(DIMENSAO_HORIZONTAL/3), trunc(DIMENSAO_VERTICAL/3), true, true, false, true);
        Set_Window_Partida ('E');
        gotoxy(3,7);
        Textcolor (cyan);
        writeln ('PARTIDA INICIANDO!');
        delay (100);
        clrscr;
        delay (100);
        inc (I);
      until I = 2;
      
      If TurnoJogador = TRUE then begin
        repeat
          window (0,0,0,0);
          Desenha_Bordas (cyan, black, 176, trunc(POSICAO_HORIZONTAL+1/3*DIMENSAO_HORIZONTAL), trunc(POSICAO_VERTICAl+1/3*DIMENSAO_VERTICAL), trunc(DIMENSAO_HORIZONTAL/3), trunc(DIMENSAO_VERTICAL/3), true, true, false, true);
          Set_Window_Partida ('E');
          gotoxy(3,7);
          Textcolor (cyan);
          writeln (' JOGADOR COMEÇA!');
          delay (100);
          clrscr;
          delay (100);
          inc (I);
        until I = 4;
      end
      
      else begin
        repeat
          window (0,0,0,0);
          Desenha_Bordas (cyan, black, 176, trunc(POSICAO_HORIZONTAL+1/3*DIMENSAO_HORIZONTAL), trunc(POSICAO_VERTICAl+1/3*DIMENSAO_VERTICAL), trunc(DIMENSAO_HORIZONTAL/3), trunc(DIMENSAO_VERTICAL/3), true, true, false, true);
          Set_Window_Partida ('E');
          gotoxy(3,7);
          Textcolor (cyan);
          writeln (' INIMIGO COMEÇA!');
          delay (100);
          clrscr;
          delay (100);
          inc (I);
        until I = 4;
      end;
      
      
      
      textcolor (lightgray);
      Escreve_Mensagem ('  USE o cursor " "' + #13#10 + '  para atacar!'+#13#10#13#10+'         '+#13#10+'              '+#13#10#13#10+'  <ENTER> '+#13#10+'  Para atirar!'+#13#10#13#10+'  '+#13#10+'   ', 'A', -1);
      set_window_partida ('A');
      gotoxy (17,7); textcolor(lightred); write (#245); textcolor(lightgray);
      
      
      Escreve_Mensagem ('FOGO!', 'B', -7) ;
      Escreve_Mensagem ('1º Tiro:', 'B', -3);
      Escreve_Mensagem ('2º Tiro:', 'B', 1);
      Escreve_Mensagem ('3º Tiro:', 'B', 5);
      Escreve_Mensagem ('-SCORE!-', 'C', -7);
      
      Set_Window_Partida ('C'); Gotoxy (9, 5); Textcolor (cyan); Write ('0'); Textcolor (white);
      
      
      
      PosicaoC.x:= (8);
      PosicaoC.y:= (15);
      
      Set_Window_Partida ('D');
      Cposicao (posicaoC, true, Tposicao);
      gotoxy (Tposicao.x, Tposicao.y); textcolor(lightred); write (#245);
      window (0,0,0,0);
      gotoxy (POSICAO_HORIZONTAL - 4, POSICAO_VERTICAL + (posicaoC.y-1)*2); textcolor (lightcyan);  // TAG DE LETRAS
      write	(Letter[posicaoC.y],'->');
      gotoxy (POSICAO_HORIZONTAL+1 + (posicaoC.x-1)*4, POSICAO_VERTICAL - 2); textcolor (lightcyan);
      write (PosicaoC.x);
      
      Set_Window_Partida ('D');
      
      window (0,0,0,0);
      I:= 2;
      repeat
        Desenha_Bordas (cyan ,black, 240, POSICAO_HORIZONTAL+1, POSICAO_VERTICAL + I, DIMENSAO_HORIZONTAL-2, 1, true, false, false, true); // LINHAS H
        Inc (I,4);
      until I >= DIMENSAO_VERTICAL - 2;
      I:= 4;
      repeat
        Desenha_Bordas (cyan, black, 221 , POSICAO_HORIZONTAL + I, POSICAO_VERTICAL, 3, DIMENSAO_VERTICAL, false, true, false, true);  // LINHAS V
        Inc (I,8);
      until I >= DIMENSAO_HORIZONTAL - 3;
      
      
      Desenha_Bordas (cyan, black, 240, NaviosCounterX + 1, NaviosCounterY + 21, 29, -1, true, false, false, false);
      
      Desenha_Bordas (blue, black, 219, LArenaATiroX, LArenaATiroY, 31, 15, true, true, false, false);           // areninha
      Desenha_Bordas (blue, black, 219, LArenaATiroX - 1, LArenaATiroY - 1, 33, 17, false, true, false, false); // para fazer quadrado GORDO
      
      
      Desenha_Bordas (cyan, black, 219, NaviosCounterX - 1, NaviosCounterY, 33, 36, true, true, false, false); // para fazer quadrado GORDO
      Desenha_Bordas (cyan, black, 219, NaviosCounterX, NaviosCounterY, 31, 36, false, true, false, false);
      
      
      
      Set_Window_Partida ('F');
      For I:=1 to 15 do begin
        For J:=1 to 15 do begin
          Posicao.x:= (I*2); Posicao.y:= J;
          gotoxy (Posicao.x, Posicao.y);
          textcolor (brown);
          If Arena[I, J].Estado <> 0 then
          write (Icone[Arena[I, J].Estado]);
        end;
      end;
      
      
      Window (0,0,0,0);
      textcolor (white);
      Conta_Navios_Restantes (50, 'W');
      
      
      
      I:=1;
      repeat                                   // VEZ DO JOGADOR
        
        If TurnoJogador = TRUE then begin
          
          Tiro_Counter:= 0;
          
          repeat
            
            cursoroff;
            
            Case (Tiro_Counter) of
              
              0: begin
                Escreve_Mensagem ('               ', 'B', -2); Escreve_Mensagem ('               ', 'B', -1);
                Escreve_Mensagem ('               ', 'B', 2); Escreve_Mensagem ('               ', 'B', 3);
              end;
              1: begin
                Escreve_Mensagem ('               ', 'B', 6); Escreve_Mensagem ('               ', 'B', 7);
              end;
            end;
            
            Set_Window_Partida ('D');
            PosicaoC_Antiga:= PosicaoC;
            Movimento_Valido:= TRUE;
            Key:= (readkey);
            case (key) of
              #0: case (readkey) of
                #72: begin //CIMA
                  dec (PosicaoC.y);
                end;
                #80: begin // BAIXO
                  inc (PosicaoC.y);
                end;
                #75: begin // ESQUERDA
                  dec (PosicaoC.x);
                end;
                #77: begin  //DIREITA
                  inc (PosicaoC.x);
                end;
              end;
              #13: begin //ENTER
                
                If Arena_Tiro[PosicaoC.x, PosicaoC.y].Estado = 0 then begin
                  gotoxy (Tposicao.x, Tposicao.y);
                  if Arena_Axel[PosicaoC.x, PosicaoC.y].Estado = 0 then begin   // AGUA
                    Arena_Tiro[PosicaoC.x, PosicaoC.y].Estado:= 12; textcolor(lightcyan);
                    ToPMessage:= '  ';
                    Write (Icone[Arena_Tiro[PosicaoC.x, PosicaoC.y].Estado]);
                    Set_Window_Partida ('G');
                    clrscr;
                  end
                  
                  else begin                                                    // NAVIO?
                    
                    Arena_Tiro[PosicaoC.x, PosicaoC.y].Estado:= Arena_Axel[PosicaoC.x, PosicaoC.y].Estado;
                    Arena_Tiro[PosicaoC.x, PosicaoC.y].ID:= Arena_Axel[PosicaoC.x, PosicaoC.y].ID;
                    
                    If Vitima[Arena_Tiro[PosicaoC.x, PosicaoC.y].ID].MaxHP = 0 then begin
                      
                      case Arena_Tiro[PosicaoC.x, PosicaoC.y].Estado of
                        
                        1, 6, 7, 8: I:= 3;
                        2: I:= 1;
                        3, 9: I:= 2;
                        4, 10: I:= 4;
                        5, 11: I:= 5;
                        
                      end;
                      
                      Vitima[Arena_Tiro[PosicaoC.x, PosicaoC.y].ID].MaxHP:= I;
                      Vitima[Arena_Tiro[PosicaoC.x, PosicaoC.y].ID].HP:= I;
                      
                    end;
                    
                    dec (Vitima[Arena_Tiro[PosicaoC.x, PosicaoC.y].ID].HP);
                    
                    If Vitima[Arena_Tiro[PosicaoC.x, PosicaoC.y].ID].HP = 0 then Vitima[Arena_Tiro[PosicaoC.x, PosicaoC.y].ID].Dead:= TRUE;
                    
                    If Vitima[Arena_Tiro[PosicaoC.x, PosicaoC.y].ID].Dead = TRUE then begin
                      
                      textcolor(red);
                      ToPMessage:= MensagemC;
                      for I:=1 to 15 do begin
                        for J:=1 to 15 do begin
                          If (Arena_Tiro[I, J].ID <> 0) AND (Arena_Tiro[I, J].ID = Arena_Tiro[PosicaoC.x, PosicaoC.y].ID) then begin
                            Posicao.x:= I;
                            Posicao.y:= J;
                            Cposicao (Posicao, true, Tposicao);
                            gotoxy (Tposicao.x, Tposicao.y);
                            Write (Icone[Arena_Tiro[I, J].Estado]);
                          end;
                        end;
                      end;
                      
                      case Arena_Tiro[PosicaoC.x, PosicaoC.y].Estado of
                        
                        1, 6, 7, 8: I:= 1;
                        2: I:= 2;
                        3, 9: I:= 3;
                        4, 10: I:= 4;
                        5, 11: I:= 5;
                      end;
                      
                      dec (Contador[I].Axel);
                      
                      Conta_Navios_Restantes (I, 'A');
                      
                      inc (NaviosDeadbyJogador);
                      
                    end
                    else begin
                      textcolor(yellow);
                      ToPMessage:= MensagemB;
                      Write (Icone[Arena_Tiro[PosicaoC.x, PosicaoC.y].Estado]);
                    end;
                    
                    Set_Window_Partida ('G');
                    clrscr;
                    Desenha_Navio_Atingido (Arena_Tiro[PosicaoC.x, PosicaoC.y].Estado, 9, 6);
                    
                  end;
                  
                  Inc (Tiro_Counter);
                  
                  BotMessage:= NAVIO_Name[Arena_Tiro[PosicaoC.x, PosicaoC.y].Estado];
                  Escreve_Mensagem (TopMessage, 'B', (-4+(Tiro_Counter*4)-2));
                  Escreve_Mensagem (BotMessage, 'B', (-4+(Tiro_Counter*4)-1));
                  
                  Calcula_Score;
                  
                end
              end;
            end;
            
            If (PosicaoC.x < 1) OR (PosicaoC.x > 15) OR (PosicaoC.y <1) OR (PosicaoC.y > 15) then Movimento_Valido:= FALSE;
            
            If (Movimento_Valido) AND  (Key <> (#13)) then begin
              Cposicao (posicaoC_antiga, true, Tposicao);
              gotoxy (Tposicao.x, Tposicao.y);
              Case Arena_Tiro[PosicaoC_Antiga.x, PosicaoC_Antiga.y].Estado of
                0: write (' ');
                12: begin textcolor (cyan);	Write (Icone[Arena_Tiro[PosicaoC_Antiga.x, PosicaoC_Antiga.y].Estado]);
                end;
                else begin
                  If Vitima[Arena_Tiro[PosicaoC_Antiga.x, PosicaoC_Antiga.y].ID].Dead = TRUE then
                  textcolor (red)
                  else textcolor (yellow);
                  Write(Icone[Arena_Tiro[PosicaoC_Antiga.x, PosicaoC_Antiga.y].Estado]);
                end;
              end;
              Cposicao (posicaoC, true, Tposicao);
              gotoxy (Tposicao.x, Tposicao.y); textcolor(lightred); write (#245);
              
              window (0,0,0,0);
              gotoxy (POSICAO_HORIZONTAL - 4, POSICAO_VERTICAL + (posicaoC_Antiga.y-1)*2); textcolor (cyan);  // TAG DE LETRAS
              write	(Letter[posicaoC_Antiga.y],'->');
              gotoxy (POSICAO_HORIZONTAL+1 + (posicaoC_Antiga.x-1)*4, POSICAO_VERTICAL - 2);
              write (posicaoC_Antiga.x);
              gotoxy (POSICAO_HORIZONTAL - 4, POSICAO_VERTICAL + (posicaoC.y-1)*2); textcolor (lightcyan);  // TAG DE LETRAS
              write	(Letter[posicaoC.y],'->');
              gotoxy (POSICAO_HORIZONTAL+1 + (posicaoC.x-1)*4, POSICAO_VERTICAL - 2); textcolor (lightcyan);
              write (PosicaoC.x);
            end
            
            else  posicaoC:= PosicaoC_Antiga;
            
            If Tiro_Counter = 3 then TurnoJogador:= FALSE;
            
            if NaviosDeadbyJogador = 15 then begin
              Finaliza_Jogo(TRUE);
              Exit;
            end;
            
          until (TurnoJogador = FALSE);
          
        end
        
        else begin      // TURNO AXEL!
          
          
          For I:=1 to 3 do begin
            
            Axel_Joga (false, true, Tiro_Axel);
            Posicao.x:= (Tiro_Axel.x*2); Posicao.y:= Tiro_Axel.y;
            Pisca[I].posicao:= Posicao;
            if Arena_Axel_Tiro[Tiro_Axel.x, Tiro_Axel.y].Estado = 12 then begin
              textcolor (cyan);
              Pisca[I].color:= cyan;
            end
            else begin
              
              
              if VitimaAxel[Arena_Axel_Tiro[Tiro_Axel.x, Tiro_Axel.y].ID].MaxHP = 0 then begin
                
                case Arena_Axel_Tiro[Tiro_Axel.x, Tiro_Axel.y].Estado of
                  1, 6, 7, 8: T:= 3;
                  2: T:= 1;
                  3, 9: T:= 2;
                  4, 10: T:= 4;
                  5, 11: T:= 5;
                end;
                
                VitimaAxel[Arena_Axel_Tiro[Tiro_Axel.x, Tiro_Axel.y].ID].MaxHP:= T;
                VitimaAxel[Arena_Axel_Tiro[Tiro_Axel.x, Tiro_Axel.y].ID].HP:= T;
                
              end;
              
              Dec (VitimaAxel[Arena_Axel_Tiro[Tiro_Axel.x, Tiro_Axel.y].ID].HP);
              
              If VitimaAxel[Arena_Axel_Tiro[Tiro_Axel.x, Tiro_Axel.y].ID].HP = 0 then begin
                
                
                
                case Arena_Axel_Tiro[Tiro_Axel.x, Tiro_Axel.y].Estado of
                  
                  1, 6, 7, 8: T:= 1;
                  2: T:= 2;
                  3, 9: T:= 3;
                  4, 10: T:= 4;
                  5, 11: T:= 5;
                  
                end;
                
                dec (Contador[T].Player);
                
                Conta_Navios_Restantes (T, 'P');
                inc (NaviosDeadbyAxel);
                
              end;
              
              Pisca[I].color:= red;
              textcolor (red);
              
            end;
            Set_Window_Partida ('F');
            gotoxy (Posicao.x, Posicao.y);
            write (Icone[Arena_Axel_Tiro[Tiro_Axel.x, Tiro_Axel.y].Estado]);
            Pisca[I].Icone:= Icone[Arena_Axel_Tiro[Tiro_Axel.x, Tiro_Axel.y].Estado];
            
            If TOTALAISHOTS >= 225  then break;
          end;
          
          
          
          Set_Window_Partida ('F');
          
          For J:= 1 to 2 do begin
            delay (300);
            For I:= 1 to 3 do begin
              gotoxy (Pisca[I].posicao.x, Pisca[I].posicao.y);
              write (' ');
            end;
            delay (300);
            For I:= 1 to 3 do begin
              gotoxy (Pisca[I].posicao.x, Pisca[I].posicao.y);
              textcolor (Pisca[I].color);
              write (Pisca[I].Icone);
            end;
          end;
          
          
          If (NaviosDeadbyAxel = 15) OR (TOTALAISHOTS >= 225) then begin
            Finaliza_Jogo(FALSE);
            Exit;
          end;
          
          TurnoJogador:= TRUE;
          
        end;
        
      until (false);
      
    end;
    //----------------------------------- // FIM Procedure 10 //----------------------------------------------------------------------- //
    
    
    //----------------------------------- // Procedure 11 //----------------------------------------------------------------------- //
    
    Procedure Finaliza_Jogo (Vitoria: Boolean);
    
    // Procedure Finializa_Jogo é responsável por gerar a tela final, após o término da partida
    
    Var
    X, Y, I, J:  Integer;
    Key: Char;
    PRIMEIRO, SEGUNDO, TERCEIRO: Char;
    PRIMEIRO_I, SEGUNDO_I, TERCEIRO_I: integer;
    LetterList: Array [1..26] of char = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z');
    Ajusta: Integer;
    Ajusta_String: String;
    Score_OUT, Score_Dummy: Pontuacao;
    TOPSCORE: boolean = FALSE;
    
    
    begin
      
      
      Window (POSICAO_HORIZONTAL, POSICAO_VERTICAL, 70, 33);
      
      clrscr;
      
      X:= 14;
      Y:= 5;
      
      
      textcolor (green);
      
      
      If Vitoria then begin
        
        case Difficulty of
          
          'E': Score:= Score + 30000;
          'N': Score:= Score + 80000;
          'H': Score:= Score + 180000;
          
        end;
        
        For I:=1 to 3 do begin
          
          gotoxy (X, Y);    writeln ('     __   __ _____  _   _     ');
          gotoxy (X, Y+1);  writeln ('     \ \ / /|  _  || | | |    ');
          gotoxy (X, Y+2);  writeln ('      \ V / | | | || | | |    ');
          gotoxy (X, Y+3);  writeln ('       \ /  | | | || | | |    ');
          gotoxy (X, Y+4);  writeln ('       | |  \ \_/ /| |_| |    ');
          gotoxy (X, Y+5);  writeln ('       \_/   \___/  \___/     ');
          gotoxy (X, Y+6);  writeln ('	                            ');
          gotoxy (X, Y+7);  writeln ('                              ');
          gotoxy (X, Y+8);  writeln ('	 _    _  _____  _   _  _  _ ');
          gotoxy (X, Y+9);  writeln ('	| |  | ||_   _|| \ | || || |');
          gotoxy (X, Y+10); writeln ('	| |  | |  | |  |  \| || || |');
          gotoxy (X, Y+11); writeln ('	| |/\| |  | |  | . ` || || |');
          gotoxy (X, Y+12); writeln ('	\  /\  / _| |_ | |\  ||_||_|');
          gotoxy (X, Y+13); writeln ('	 \/  \/  \___/ \_| \_/(_)(_)');
          
          delay (300);
          
          if I < 3 then
          clrscr;
          
          delay (300);
          
        end;
      end
      
      else begin
        
        For I:=1 to 3 do begin
          
          gotoxy (X, Y);    writeln ('      __   __ _____  _   _        ');
          gotoxy (X, Y+1);  writeln ('      \ \ / /|  _  || | | |       ');
          gotoxy (X, Y+2);  writeln ('       \ V / | | | || | | |       ');
          gotoxy (X, Y+3);  writeln ('        \ /  | | | || | | |       ');
          gotoxy (X, Y+4);  writeln ('        | |  \ \_/ /| |_| |       ');
          gotoxy (X, Y+5);  writeln ('        \_/   \___/  \___/        ');
          gotoxy (X, Y+6);  writeln ('                                  ');
          gotoxy (X, Y+7);  writeln ('                                  ');
          gotoxy (X, Y+8);  writeln (' _      _____  _____  _____  _  _ ');
          gotoxy (X, Y+9);  writeln ('| |    |  _  |/  ___||  ___|| || |');
          gotoxy (X, Y+10); writeln ('| |    | | | |\ `--. | |__  | || |');
          gotoxy (X, Y+11); writeln ('| |    | | | | `--. \|  __| | || |');
          gotoxy (X, Y+12); writeln ('| |____\ \_/ //\__/ /| |___ |_||_|');
          gotoxy (X, Y+13); writeln ('\_____/ \___/ \____/ \____/ (_)(_)');
          
          delay (300);
          
          if I < 3 then
          clrscr;
          
          delay (300);
          
        end;
        
      end;
      
      
      X:= 18;
      Y:= 5;
      I:= 1;
      J:= 1;
      
      Gotoxy (X + 5, Y + 15); textcolor (white); write ('--TOTAL SCORE--');
      
      
      str (Score, Ajusta_String);
      Ajusta:= Length (Ajusta_String);
      Ajusta:= Int (Ajusta/2);
      
      textcolor (cyan);
      Gotoxy (X + 12 - Ajusta , Y + 16); write (score);
      
      textcolor (white);
      textbackground (blue);
      Gotoxy (X + 8 + J*2, Y + 18); write (LetterList[I]); inc (J);
      textbackground (black);
      Gotoxy (X + 8 + J*2, Y + 18); write (LetterList[I]); inc (J);
      Gotoxy (X + 8 + J*2, Y + 18); write (LetterList[I]);
      
      Gotoxy (X + J*2 - 5, Y + 21); write ('<SPACEBAR>'); textcolor (green); write (' TO SAVE&EXIT');
      
      J:= 1;
      
      PRIMEIRO:= 'A';
      SEGUNDO:= 'A';
      TERCEIRO:= 'A';
      PRIMEIRO_I:= 1;
      SEGUNDO_I:= 1;
      TERCEIRO_I:= 1;
      
      
      textcolor (white);
      
      repeat
        textbackground (black);
        key:= (readkey);
        cursoroff;
        
        case (key) of
          
          #0: begin
            
            case (readkey) of
              
              #72: begin //CIMA
                
                dec (I);
                if I < 1 then I:= 26;
              end;
              
              #80: begin // BAIXO
                
                inc (I);
                if I > 26 then I:= 1;
              end;
              
              #77: begin  //DIREITA
                
                textbackground (black);
                Gotoxy (X + 8 + J*2, Y + 18); write (LetterList[I]);
                
                case (J) of
                  
                1: begin PRIMEIRO:= LetterList[I]; PRIMEIRO_I:= I; I:= SEGUNDO_I; end;
                2: begin SEGUNDO:= LetterList[I];  SEGUNDO_I:= I; I:= TERCEIRO_I; end;
                3: begin TERCEIRO:= LetterList[I]; TERCEIRO_I:= I; I:= PRIMEIRO_I; end;
                  
                end;
                
                inc (J);
                if J > 3 then J:= 1;
                
              end;
              
              #75: begin // ESQUERDA
                
                textbackground (black);
                Gotoxy (X + 8 + J*2, Y + 18); write (LetterList[I]);
                
                case (J) of
                  
                1: begin PRIMEIRO:= LetterList[I]; PRIMEIRO_I:= I; I:= TERCEIRO_I; end;
                2: begin SEGUNDO:= LetterList[I];  SEGUNDO_I:= I; I:= PRIMEIRO_I; end;
                3: begin TERCEIRO:= LetterList[I]; TERCEIRO_I:= I; I:= SEGUNDO_I; end;
                  
                end;
                
                dec (J);
                if J < 1 then J:= 3;
                
              end;
              
            end;
            
            Gotoxy (X + 8 + J*2, Y + 18); textbackground (blue); write (LetterList[I]);
            
          end;
          
          
          
          #32: begin
            
            textbackground (black);
            Gotoxy (X + 8 + J*2, Y + 18);
            write (LetterList[I]);
            
            
            case (J) of
              
              1: PRIMEIRO:= LetterList[I];
              2: SEGUNDO:= LetterList[I];
              3: TERCEIRO:= LetterList[I];
              
            end;
            
            Score_OUT.Nome[1]:= PRIMEIRO;
            Score_OUT.Nome[2]:= SEGUNDO;
            Score_OUT.Nome[3]:= TERCEIRO;
            Score_OUT.Pontos:= Score;
            
            
            For I:=1 to 10 do begin
              
              If Score > Score_List[I].Pontos then begin
                TOPSCORE:= TRUE;
                break;
              end;
            end;
            
            If TOPSCORE = TRUE then begin
              
              For J:= I to 10 do begin
                Score_Dummy:= Score_OUT;
                Score_OUT:= Score_List[J];
                Score_List[J]:= Score_Dummy;
              end;
            end;
            
            Score:= 0;
            
            
            For I:=1 to 10 do
            MemoryCard[I].Save:= Score_List[I];
            Reset(Arq);
            For I:=1 to 11 do
            write (arq, MemoryCard[I]);
            close (arq);
            
            
            delay (3000);
            
            exit;
          end;
        end;
        
        
      until (false);
      
      
      readln;
      readln;
      
      window (0,0,0,0);
      clrscr;
      
      NOVO:= TRUE;
      
    end;
    
    //----------------------------------- // FIM - Procedure 10 //----------------------------------------------------------------------- //
    
    
    //----------------------------------- // Procedure 11 //----------------------------------------------------------------------- //
    
    Procedure Open_Scores;
    
    // Procedure Open_Scores é responsável por abrir a tela de Scores no Menu Principal
    
    Var
    
    AncoraX, AncoraY, AncoraZ, AncoraW, AncoraK, AncoraJ: Integer;
    Ajusta: Integer;
    Ajusta_String: String;
    
    
    begin
      
      AncoraX:= 15;          			// borda e tudo dentro
      AncoraY:= 5;
      AncoraZ:= AncoraX +7;       // title
      AncoraW:= AncoraY +3;
      AncoraK:= AncoraX +36;      // scores
      AncoraJ:= AncoraY +13;
      
      window (0,0,0,0);
      clrscr;
      
      Desenha_Bordas (green, black, 254, AncoraX, AncoraY, 71, 50, true, true, false, false);
      
      
      
      textcolor (lightgreen);
      
      Gotoxy (AncoraZ,AncoraW+1); Write ('  __________  ____     _____ __________  ____  ___________');
      Gotoxy (AncoraZ,AncoraW+2); Write (' /_  __/ __ \/ __ \   / ___// ____/ __ \/ __ \/ ____/ ___/');
      Gotoxy (AncoraZ,AncoraW+3); Write ('  / / / / / / /_/ /   \__ \/ /   / / / / /_/ / __/  \__ \ ');
      Gotoxy (AncoraZ,AncoraW+4); Write (' / / / /_/ / ____/   ___/ / /___/ /_/ / _, _/ /___ ___/ / ');
      Gotoxy (AncoraZ,AncoraW+5); Write ('/_/  \____/_/       /____/\____/\____/_/ |_/_____//____/  ');
      
      
      
      str (Score_List[1].Pontos, Ajusta_String);
      Ajusta:= Length (Ajusta_String);
      Ajusta:= Int (Ajusta/2);
      
      
      textcolor (brown);
      gotoxy (AncoraK-27, AncoraJ+1);write(' '#220);
      gotoxy (AncoraK-27, AncoraJ+2);write(#223#219'  '#175);
      gotoxy (AncoraK-27, AncoraJ+3);write(#223#223#223);
      
      Gotoxy (AncoraK-21, AncoraJ+2);  textcolor (green); write (Score_List[1].Nome[1], ' ', Score_List[1].Nome[2], ' ', Score_List[1].Nome[3]);
      Gotoxy (AncoraK+17, AncoraJ+2);  textcolor (cyan); write  (Score_List[1].Pontos);
      
      
      textcolor (lightgreen);
      Gotoxy (AncoraK-25, AncoraJ+5); textcolor (lightgray); write  ('2 '#175' '); textcolor (green); write (Score_List[2].Nome[1], ' ', Score_List[2].Nome[2], ' ', Score_List[2].Nome[3]);
      Gotoxy (AncoraK +17, AncoraJ+5); textcolor (cyan); write  (Score_List[2].Pontos);
      
      textcolor (lightgreen);
      Gotoxy (AncoraK-25, AncoraJ+8); textcolor (lightgray); write  ('3 '#175' '); textcolor (green); write (Score_List[3].Nome[1], ' ', Score_List[3].Nome[2], ' ', Score_List[3].Nome[3]);
      Gotoxy (AncoraK +17, AncoraJ+8); textcolor (cyan); write  (Score_List[3].Pontos);
      
      textcolor (lightgreen);
      Gotoxy (AncoraK-25, AncoraJ+11); textcolor (lightgray); write  ('4 '#175' '); textcolor (green); write (Score_List[4].Nome[1], ' ', Score_List[4].Nome[2], ' ', Score_List[4].Nome[3]);
      Gotoxy (AncoraK +17, AncoraJ+11); textcolor (cyan); write  (Score_List[4].Pontos);
      
      textcolor (lightgreen);
      Gotoxy (AncoraK-25, AncoraJ+14); textcolor (lightgray); write  ('5 '#175' '); textcolor (green); write (Score_List[5].Nome[1], ' ', Score_List[5].Nome[2], ' ', Score_List[5].Nome[3]);
      Gotoxy (AncoraK +17, AncoraJ+14); textcolor (cyan); write  (Score_List[5].Pontos);
      
      textcolor (lightgreen);
      Gotoxy (AncoraK-25, AncoraJ+17); textcolor (lightgray); write  ('6 '#175' '); textcolor (green); write (Score_List[6].Nome[1], ' ', Score_List[6].Nome[2], ' ', Score_List[6].Nome[3]);
      Gotoxy (AncoraK +17, AncoraJ+17); textcolor (cyan); write  (Score_List[6].Pontos);
      
      textcolor (lightgreen);
      Gotoxy (AncoraK-25, AncoraJ+20); textcolor (lightgray); write  ('7 '#175' '); textcolor (green); write (Score_List[7].Nome[1], ' ', Score_List[7].Nome[2], ' ', Score_List[7].Nome[3]);
      Gotoxy (AncoraK +17, AncoraJ+20); textcolor (cyan); write  (Score_List[7].Pontos);
      
      textcolor (lightgreen);
      Gotoxy (AncoraK-25, AncoraJ+23); textcolor (lightgray); write  ('8 '#175' '); textcolor (green); write (Score_List[8].Nome[1], ' ', Score_List[8].Nome[2], ' ', Score_List[8].Nome[3]);
      Gotoxy (AncoraK +17, AncoraJ+23); textcolor (cyan); write  (Score_List[8].Pontos);
      
      textcolor (lightgreen);
      Gotoxy (AncoraK-25, AncoraJ+26); textcolor (lightgray); write  ('9 '#175' '); textcolor (green); write (Score_List[9].Nome[1], ' ', Score_List[9].Nome[2], ' ', Score_List[9].Nome[3]);
      Gotoxy (AncoraK +17, AncoraJ+26); textcolor (cyan); write  (Score_List[9].Pontos);
      
      textcolor (lightgreen);
      Gotoxy (AncoraK-25, AncoraJ+29); textcolor (lightgray); write  ('10 '#175' '); textcolor (green); write (Score_List[10].Nome[1], ' ', Score_List[10].Nome[2], ' ', Score_List[10].Nome[3]);
      Gotoxy (AncoraK +17, AncoraJ+29); textcolor (cyan); write  (Score_List[10].Pontos);
      
      
      
      
      Gotoxy (AncoraK - 11, AncoraJ+33); textcolor (lightgray); write  ('PRESS ANY <KEY> TO EXIT');
      
      readln;
      
      clrscr;
      
      exit;
      
    end;
    
    //----------------------------------- // Procedure 11 //----------------------------------------------------------------------- //
    
    
    //----------------------------------- // Procedure 12 //----------------------------------------------------------------------- //
    
    
    Procedure Open_Options;
    
    // Procedure Open_Options é responsável por abrir o menu de Opções (que tá mais para opção, no singular) no Menu Principal
    
    Var
    
    AncoraX, AncoraY: Integer;
    dump:XY;
    EstadoOptions, EstadoOptionsAntigo: Integer;
    Key: char;
    
    begin
      
      AncoraX:= 25;
      AncoraY:= 6;
      
      
      clrscr;
      
      Desenha_Bordas (black, green, 176, AncoraX, AncoraY, 50, 10, true, true, true, false);
      Desenha_Bordas (black, green, 176, AncoraX + 11, AncoraY + 13, 29, 8, true, true, true, false);
      
      textcolor (green); textbackground (black);
      Window (AncoraX, AncoraY, AncoraX + 49, AncoraY + 9);
      Centraliza_Texto ('Options', 50, 50, -4, 0, dump );
      
      window (AncoraX + 11,AncoraY + 13, AncoraX + 39, AncoraY + 20);
      
      Centraliza_Texto ('Difficulty', 29, 29, -1, 0, dump);
      
      Centraliza_Texto ('Easy', 29, 29, -4, 4, dump);
      Centraliza_Texto ('Normal', 29, 29, -4, 0, dump);
      Centraliza_Texto ('Hard', 29, 29, -4, 22, dump);
      
      textcolor (black); textbackground (green);
      Case Difficulty of
      'E': begin Centraliza_Texto ('Easy', 29, 29, -4, 4, dump); EstadoOptions:= 1; end;
      'N': begin Centraliza_Texto ('Normal', 29, 29, -4, 0, dump); EstadoOptions:= 2; end;
      'H': begin Centraliza_Texto ('Hard', 29, 29, -4, 22, dump); EstadoOptions:= 3; end;
      end;
      
      repeat
        
        EstadoOptionsAntigo:= EstadoOptions;
        textbackground (black); Cursoroff;
        Key:= (readkey);
        case (key) of
          
          #0: case (readkey) of
            #72, #75:	case (EstadoOptions) of				//PARA CIMA / ESQUERDA
              1:	EstadoOptions:= 3;
              2:  EstadoOptions:= 1;
              3:	EstadoOptions:= 2;
            end;
            #80, #77:	case (EstadoOptions) of				//PARA BAIXO / DIREITA
              1: 	EstadoOptions:= 2;
              2:	EstadoOptions:= 3;
              3:	EstadoOptions:= 1;
            end;
          end;
          #13: begin                  							//ENTER
            case EstadoOptions of
              1: Difficulty:= 'E';
              2: Difficulty:= 'N';
              3: Difficulty:= 'H';
            end;
            
            MemoryCard[11].Difficulty:= Difficulty;
            Reset (Arq);
            For I:=1 to 11 do
            Write (Arq, MemoryCard[I]);  Close (Arq);
            
            
            window (0,0,0,0); textbackground (black); clrscr; Exit;
          end;
        end;
        
        textcolor (green); textbackground (black);
        Case EstadoOptionsAntigo of
          
          1: Centraliza_Texto ('Easy', 29, 29, -4, 4, dump);
          2: Centraliza_Texto ('Normal', 29, 29, -4, 0, dump);
          3: Centraliza_Texto ('Hard', 29, 29, -4, 22, dump);
          
        end;
        textcolor (black); textbackground (green);
        Case EstadoOptions of
          
          1: Centraliza_Texto ('Easy', 29, 29, -4, 4, dump);
          2: Centraliza_Texto ('Normal', 29, 29, -4, 0, dump);
          3: Centraliza_Texto ('Hard', 29, 29, -4, 22, dump);
          
        end;
        
      Until (false);
      
    end;
    
    //----------------------------------- // FIM - Procedure 12 //----------------------------------------------------------------------- //  
		
		
		
		
		
		  
    
    begin // PROGRAMA PRINCIPAL
      
      
      
      POSICAO_HORIZONTAL:= 12;    // BIG ARENA
      POSICAO_VERTICAL:= 5;
      StatusScreenX:= 12;         // STATUS
      StatusScreenY:= 3;
      LArenaATiroX:= 76;      		// Areninha (arena_axel_tiro)
      LArenaATiroY:= 43;
      NavioResX:= 86;         		// HP navios lista (em cima)
      NavioResY:= 10;
      MNavioResX:= 80;        		// HP navios aglomerados (em baixo)
      MNavioResY:= 31;
      NaviosCounterX:= 76;        // Contador de Navios
      NaviosCounterY:= 5;
      
      NOVO:= FALSE;
      SAIR:= FALSE;
      
      
      Score_List[1].Nome[1]:= 'J'; Score_List[1].Nome[2]:= 'H'; Score_List[1].Nome[3]:= 'Z'; Score_List[1].Pontos:= 500;
      Score_List[2].Nome[1]:= 'A'; Score_List[2].Nome[2]:= 'X'; Score_List[2].Nome[3]:= 'E'; Score_List[2].Pontos:= 450;
      Score_List[3].Nome[1]:= 'C'; Score_List[3].Nome[2]:= 'A'; Score_List[3].Nome[3]:= 'P'; Score_List[3].Pontos:= 400;
      Score_List[4].Nome[1]:= 'N'; Score_List[4].Nome[2]:= 'U'; Score_List[4].Nome[3]:= 'B'; Score_List[4].Pontos:= 350;
      Score_List[5].Nome[1]:= 'T'; Score_List[5].Nome[2]:= 'A'; Score_List[5].Nome[3]:= 'T'; Score_List[5].Pontos:= 300;
      Score_List[6].Nome[1]:= 'L'; Score_List[6].Nome[2]:= 'O'; Score_List[6].Nome[3]:= 'L'; Score_List[6].Pontos:= 250;
      Score_List[7].Nome[1]:= 'G'; Score_List[7].Nome[2]:= 'U'; Score_List[7].Nome[3]:= 'D'; Score_List[7].Pontos:= 200;
      Score_List[8].Nome[1]:= 'W'; Score_List[8].Nome[2]:= 'O'; Score_List[8].Nome[3]:= 'W'; Score_List[8].Pontos:= 150;
      Score_List[9].Nome[1]:= 'Z'; Score_List[9].Nome[2]:= 'Z'; Score_List[9].Nome[3]:= 'Z'; Score_List[9].Pontos:= 100;
      Score_List[10].Nome[1]:= 'U'; Score_List[10].Nome[2]:= 'W'; Score_List[10].Nome[3]:= 'U'; Score_List[10].Pontos:= 090;
      
      
      Difficulty:= 'N';
      
      For I:=1 to 10 do
      MemoryCard[I].Save:= Score_List[I];
      MemoryCard[11].Difficulty:= 'N';
      
      
      GetDir (0, Directory);
      Directory:=  Directory + ('\BN-scores.bts');
      Assign (Arq, Directory);
    Append (Arq); Close (Arq);
    
    Reset(Arq); Read (Arq, MemoryCardDummy[1]); close (Arq);
    
    
    If MemoryCardDummy[1].Save.Pontos = 0 then begin
      Rewrite (Arq);
      For I:= 1 to 11 do
      Write (Arq, MemoryCard[I])
    end
    else begin
      Reset (Arq);
      For I:= 1 to 11 do
      Read (Arq, MemoryCard[I]);
      
      For I:=1 to 10 do
      Score_List[I]:= MemoryCard[I].Save;
      Difficulty:= MemoryCard[11].Difficulty;
    end;
    
    Close (Arq);
    
    
    If (Memorycard[11].Difficulty = ('E')) OR (Memorycard[11].Difficulty = ('N')) OR (Memorycard[11].Difficulty = ('H')) then
    Difficulty:= Memorycard[11].Difficulty;
    
    
    repeat
      
      
      Abrir_Tela_Inicial (EstadoInicial);
      case (EstadoInicial) of
        2: begin
          Window(0,0,0,0);
          clrscr;
          repeat
            Abrir_Arena_Jogo (Arena);
            If SAIR = FALSE then
            Inicia_Partida (Arena);
          until NOVO = FALSE;
          Window(0,0,0,0);
          clrscr;
          SAIR:= FALSE;
        end;
        
        3: begin
          
          Open_Scores;
          
        end;
        
        4: begin
          
          Open_Options
          
        end
        
        else exit;
        
      end;
      
    until (false);
    
  End.