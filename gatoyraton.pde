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
  Player winner = isWinner(players);
  if (winner != null) {
    String result = "The winner is: " + winner.nombre;
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
  }
}

Player isWinner(Player[] players) {
  for (Player p : players) {
    // Check rows
    for (int i = 0; i < rows; i++) {
      if (grid[0][i].filledBy == p && grid[1][i].filledBy == p && grid[2][i].filledBy == p) {
        return p;
      }
    }

    // Check columns
    for (int i = 0; i < cols; i++) {
      if (grid[i][0].filledBy == p && grid[i][1].filledBy == p && grid[i][2].filledBy == p) {
        return p;
      }
    }

    // Check diagonal 1
    if (grid[0][0].filledBy == p && grid[1][1].filledBy == p && grid[2][2].filledBy == p) {
      return p;
    }

    // Check diagonal 2
    if (grid[0][2].filledBy == p && grid[1][1].filledBy == p && grid[2][0].filledBy == p) {
      return p;
    }
  }

  return null;
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
          
          
          int randomCol = (int) random(0, cols);
          int randomRow = (int) random(0, rows);
          while (grid[randomCol][randomRow].filledBy != null) {
            randomCol = (int) random(0, cols);
            randomRow = (int) random(0, rows);
          }
          grid[randomCol][randomRow].filledBy = player2;
          filledCells++;
          
          
        }
       
      }
     
    }
  }
 
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
