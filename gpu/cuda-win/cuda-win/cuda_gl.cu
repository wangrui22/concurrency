#ifdef WIN32
#include "../include/gl/glew.h"
#include "../include/gl/freeglut.h"
#else 
#include "GL/glew.h"
#include "GL/freeglut.h"
#endif

#include <cuda_runtime.h>
#include <cuda.h>  
#include <cuda_gl_interop.h>
#include <cuda_texture_types.h>
#include <vector_types.h>
#include <iostream>
#include <fstream>

static int _win_width = 1024;
static int _win_height = 1024;
static GLuint _tex_id;
static GLuint _tex_id_const;
static unsigned char* _tex_buffer = nullptr;
cudaGraphicsResource* _cuda_gl_resource = nullptr;
cudaArray *_cuda_array = nullptr;
texture<uchar3, cudaTextureType2D, cudaReadModeElementType> _tex_ref;

void gl_init() {
    _tex_buffer = new unsigned char[_win_width*_win_height*3];
    int tag_x = 0;
    int tag_y = 0;
    int idx = 0;
    for (int y = 0; y < _win_height; ++y) {
        for (int x = 0; x < _win_width; ++x) {
            tag_x = x/32;
            tag_y = y/32;
            idx = y*_win_width + x;
            if ((tag_x + tag_y) % 2 == 0) {
                _tex_buffer[idx*3] = 200;
                _tex_buffer[idx * 3+1] = 200;
                _tex_buffer[idx * 3+2] = 200;
            }
            else {
                _tex_buffer[idx * 3] = 20;
                _tex_buffer[idx * 3 + 1] = 20;
                _tex_buffer[idx * 3 + 2] = 20;
            }

        }
    }
    
    {
        //debug
        /*std::ofstream out("D:/temp/tex.raw",std::ios::out|std::ios::binary);
        if (out.is_open()) {
            out.write((char*)_tex_buffer, _win_width*_win_height*3);
        }
        out.close();*/
    }
    
    glEnable(GL_TEXTURE_2D);
    
    glGenTextures(1, &_tex_id_const);
    glBindTexture(GL_TEXTURE_2D, _tex_id_const);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB8, _win_width, _win_height, 0, GL_RGB, GL_UNSIGNED_BYTE, _tex_buffer);

    glGenTextures(1, &_tex_id);
    glBindTexture(GL_TEXTURE_2D, _tex_id);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB8, _win_width, _win_height, 0, GL_RGB, GL_UNSIGNED_BYTE, _tex_buffer);


    

}

void cuda_init() {
    glBindTexture(GL_TEXTURE_2D, _tex_id);
    cudaError_t err = cudaGraphicsGLRegisterImage(&_cuda_gl_resource, _tex_id, GL_TEXTURE_2D, cudaGraphicsRegisterFlagsNone);
    if (err != CUDA_SUCCESS) {
        std::cout << "regtister GL image failed.\n";
        return;
    }
    
    //when shutdown tht application . should call cudaGraphicsUnregisterResource
}


//read const checkboard change some value , write to new texture(PBO)
__global__ update_checkboard() {
    
}   

void cuda_update_checkboard() {
    cudaGraphicsMapResources(1, &_cuda_gl_resource, 0);
    cudaGraphicsSubResourceGetMappedArray(&_cuda_array, _cuda_gl_resource, 0,0);
    cudaBindTextureToArray(tex_ref, (cudaArray*)_cuda_array);

    //launch kernel

    cudaGraphicsUnmapResources(1,&_cuda_gl_resource,0);

    //test
}

void cuda_use


void display() {
    glClearColor(0,0,0,0);
    glClearDepth(0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glPushMatrix();
    glPushAttrib(GL_ALL_ATTRIB_BITS);

    glDisable(GL_BLEND);
    glDepthMask(GL_FALSE);
    glDisable(GL_DEPTH_TEST);


    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    //glColor3f(1.0f,0.0f,0.0f);
    glBindTexture(GL_TEXTURE_2D, _tex_id);
    glBegin(GL_QUADS);
    glTexCoord2f(0,0);
    glVertex2d(-1.0, -1.0);
    glTexCoord2f(1, 0);
    glVertex2d(1.0, -1.0);
    glTexCoord2f(1, 1);
    glVertex2d(1.0, 1.0);
    glTexCoord2f(0, 1);
    glVertex2d(-1.0, 1.0);
    glEnd();
    
    glPopAttrib();
    glPopMatrix();
    
    glutSwapBuffers();
}


int cuda_gl(int argc, char* argv[]) {
    
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GL_RGB);
    glutInitWindowPosition(0, 0);
    glutInitWindowSize(_win_width,_win_height);
    glutCreateWindow("cuda GL");
    
    if (GLEW_OK != glewInit()) {
        std::cout << "Init glew failed!\n";
        return -1;
    }

    gl_init();
    cuda_init();

    glutDisplayFunc(display);
    glutMainLoop();

    return 0;
}