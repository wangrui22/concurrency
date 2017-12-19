#include <iostream>
#include "../include/gl/glew.h"
#include "../include/gl/freeglut.h"

static int _win_width = 1024;
static int _win_height = 1024;

void display() {
    glClearColor(1, 0, 0, 0);
    glClearDepth(1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glutSwapBuffers();
}


int cuda_gl(int argc, char* argv[]) {

    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GL_RGBA);
    glutInitWindowPosition(0, 0);
    glutInitWindowSize(_win_width, _win_height);
    glutCreateWindow("cuda GL");

    if (GLEW_OK != glewInit()) {
        std::cout << "Init glew failed!\n";
        return -1;
    }

    glutDisplayFunc(display);
    glutMainLoop();

    return 0;
}