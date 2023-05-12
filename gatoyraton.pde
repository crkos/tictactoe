Cell[][] grid;
int cols = 3;
int rows = 3;

Player player1 = new Player(color(255, 0, 0), "Jugador");
Player player2 = new Player(color(0, 255, 0), "BOT");
Player currentPlayer = player1;

void setup() {
  size(500, 500);
  grid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j] = new Cell(i * 166.6, j * 166.6, 166.6, 166.6);
    }
  }
}

void draw() {
  background(0);
  frameRate(12);
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j].display();
      grid[i][j].drawShape();
    }
  }
  Player[] players = {player1, player2};
  boolean winner = false;
  boolean player1Winner = false, player2Winner = false;
  
  if(isWinner(player1)) {
    player1Winner = true;
    winner = true;
  } else if (isWinner(player2)) {
    player2Winner = true;
    winner = true;
  }
  if (winner != false) {
    String result = "The winner is: ";
    if(player1Winner) {
      result += "Humano";
    } else if(player2Winner) {
      result += "BOT";
    }
    textSize(32);
    fill(255, 255, 0);
    text(result, width/2-textWidth(result)/2, height/2-16);
    noLoop();
  } else if (filledCells == 9) {
    String result = "Draw!";
    textSize(32);
    fill(255, 255, 0);
    text(result, width/2-textWidth(result)/2, height/2-16);
    noLoop();
  } else if (currentPlayer == player2) {
    // Bot's turn
    minimax(0, currentPlayer);
    currentPlayer = player1; // Switch back to player1
  }
}

boolean isWinner(Player player) {
  // Check rows
  for (int i = 0; i < rows; i++) {
    if (grid[0][i].filledBy == player && grid[1][i].filledBy == player && grid[2][i].filledBy == player) {
      return true;
    }
  }

  // Check columns
  for (int i = 0; i < cols; i++) {
    if (grid[i][0].filledBy == player && grid[i][1].filledBy == player && grid[i][2].filledBy == player) {
      return true;
    }
  }

  // Check diagonal 1
  if (grid[0][0].filledBy == player && grid[1][1].filledBy == player && grid[2][2].filledBy == player) {
    return true;
  }

  // Check diagonal 2
  if (grid[0][2].filledBy == player && grid[1][1].filledBy == player && grid[2][0].filledBy == player) {
    return true;
  }

  return false;
}


int filledCells = 0;

void mousePressed() {
  if (filledCells == 9) {
    println("Game over! All cells are filled.");
    return;
  }

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (mouseX >= grid[i][j].x && mouseX <= grid[i][j].x + grid[i][j].w &&
          mouseY >= grid[i][j].y && mouseY <= grid[i][j].y + grid[i][j].h) {
        if (grid[i][j].filledBy == null) {
          grid[i][j].filledBy = player1;
          filledCells++;
          if (filledCells == 9) {
            println("Game over! All cells are filled.");
            return;
          }
          
          currentPlayer = player2; // Switch to bot's turn
        }
      }
    }
  }
}

int minimax(int depth, Player player) {
  if (isWinner(player1) != false) {
    // Player1 wins
    return -10;
  } else if (isWinner(player2) != false) {
    // Player2 (bot) wins
    return 10;
  } else if (filledCells == 9) {
    // It's a draw
    return 0;
  }
  
  int bestScore;
  int bestMoveX = -1;
  int bestMoveY = -1;

  if (player == player2) {
    bestScore = Integer.MIN_VALUE;
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (grid[i][j].filledBy == null) {
          // Make a move for the bot
          grid[i][j].filledBy = player2;
          filledCells++;

          // Recursively call minimax for the opponent (player1)
          int score = minimax(depth + 1, player1);

          // Undo the move
          grid[i][j].filledBy = null;
          filledCells--;

          // Update the best score and move if necessary
          if (score > bestScore) {
            bestScore = score;
            bestMoveX = i;
            bestMoveY = j;
          }
        }
      }
    }
  } else {
    bestScore = Integer.MAX_VALUE;
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (grid[i][j].filledBy == null) {
          // Make a move for player1
          grid[i][j].filledBy = player1;
          filledCells++;

          // Recursively call minimax for the opponent (bot)
          int score = minimax(depth + 1, player2);

          // Undo the move
          grid[i][j].filledBy = null;
          filledCells--;

          // Update the best score and move if necessary
          if (score < bestScore) {
            bestScore = score;
            bestMoveX = i;
            bestMoveY = j;
          }
        }
      }
    }
  }

  if (depth == 0) {
    // Make the best move for the bot
    grid[bestMoveX][bestMoveY].filledBy = player2;
    filledCells++;
  }

  return bestScore;
}


class Player {
  int Color;
  String nombre;
  Player(int tempColor, String nombrePlayer) {
    Color = tempColor;
    nombre = nombrePlayer;
  }
}

class Cell {
  float x, y;
  float w, h;
  Player filledBy;

  Cell(float tempX, float tempY, float tempW, float tempH) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    filledBy = null;
  }

  void display() {
    stroke(255);
    fill(50);
    rect(x, y, w, h);
  }

  void drawShape() {
  if (filledBy != null) {
    fill(filledBy.Color);
    if (filledBy == player1) {
      ellipse(x + w/2, y + h/2, w/2, h/2);
    } else {
      line(x + w*0.2, y + h*0.2, x + w*0.8, y + h*0.8);
      line(x + w*0.2, y + h*0.8, x + w*0.8, y + h*0.2);
    }
  }
}
}
