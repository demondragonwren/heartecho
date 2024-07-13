#include "raylib.h"

// Constants
const int screenWidth = 800;
const int screenHeight = 450;
const float introDuration = 6.33f;

// Global Variables
float timeElapsed = 0.0f;
bool onIntroScreen = true;
Music music;

void InitGame() {
    // Initialization
    InitWindow(screenWidth, screenHeight, "Ultra Compact Elegant Game Intro");
    InitAudioDevice();
    music = LoadMusicStream("CUTEDEPRESSED.mp3");
    PlayMusicStream(music);
}

void UpdateGame() {
    // Update time elapsed
    timeElapsed += GetFrameTime();
    UpdateMusicStream(music);

    // Switch to menu screen after intro
    if (onIntroScreen && timeElapsed >= introDuration) {
        onIntroScreen = false;
    }

    // Handle button clicks
    if (!onIntroScreen) {
        if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) {
            Vector2 mousePoint = GetMousePosition();
            if (CheckCollisionPointRec(mousePoint, (Rectangle){ screenWidth/2 - 50, 200, 100, 30 })) {
                // Start button clicked, start the game
                // Placeholder for starting the game
                ClearBackground(RAYWHITE);
                DrawText("Game Started", screenWidth/2 - MeasureText("Game Started", 20)/2, screenHeight/2 - 10, 20, LIGHTGRAY);
                EndDrawing();
                return;
            }
            // Additional buttons can be handled here (e.g., saves, settings)
        }
    }
}

void DrawIntroScreen() {
    // Draw Intro Screen
    ClearBackground(RAYWHITE);
    DrawText("bxymf presents...", screenWidth/2 - MeasureText("bxymf presents...", 20)/2, screenHeight/2 - 10, 20, LIGHTGRAY);
}

void DrawMenuScreen() {
    // Draw Menu Screen
    ClearBackground(RAYWHITE);
    DrawText("start", screenWidth/2 - 50, 200, 20, LIGHTGRAY);
    DrawText("saves", screenWidth/2 - 50, 250, 20, LIGHTGRAY);
    DrawText("settings", screenWidth/2 - 50, 300, 20, LIGHTGRAY);
}

void UnloadResources() {
    UnloadMusicStream(music);
    CloseAudioDevice();
    CloseWindow();
}

int main() {
    InitGame();

    while (!WindowShouldClose()) {
        UpdateGame();

        BeginDrawing();
        if (onIntroScreen) {
            DrawIntroScreen();
        } else {
            DrawMenuScreen();
        }
        EndDrawing();
    }

    UnloadResources();
    return 0;
}

