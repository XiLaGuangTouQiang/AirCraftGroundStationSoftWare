#ifndef PFD_LAYER_H
#define PFD_LAYER_H

#include <QOpenGLWidget>
#include <QOpenGLContext>
#include <QOffscreenSurface>
#include <QKeyEvent>
#include <QMouseEvent>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "gl/oglx.h"
#include "gl/gl.h"
#include "gl/glut.h"
#include "gl/sgl.h"
#include "Pages/PFD_Controller_macro.h"
#include "Pages/inital_format.h"

#define CHOOSE_LVDS_VGA		0
#define DEFAULT_DISPLAY_WIDTH       1680
#define DEFAULT_DISPLAY_HEIGHT      1050
#define WIDGET_LIB_MAX_TEXTURES     2048U

extern WU_PFD_Controller CTX_PFD_Controller;
extern inC_PFD_Controller inputPfd;
extern void IoAnimate();

class pfd_layer : public QOpenGLWidget {
    Q_OBJECT

public:
    pfd_layer(QWidget *parent);
    ~pfd_layer();

    GLint timer_value = 20;
    GLint fps = 1;
    GLint pause = 0;  //const static
    GLint rawlinemode = 0;
    GLenum glErrorStatus = GL_NO_ERROR;


    sgl_type_statemachine pfd_sgl_context;
    sgl_parameters lParameters;
    SGLbyte glob_tub_texture_buffer[4U * SGL_TEXTURE_MAX_WIDTH * SGL_TEXTURE_MAX_HEIGHT];
    sgl_texture_attrib glob_texture_attrib[WIDGET_LIB_MAX_TEXTURES];
    QOffscreenSurface surface;
    QOpenGLContext context;
    //extern WU_PFD_Controller CTX_PFD_Controller;
    //inC_PFD_Controller* p_CTX_PFD_Controller;

protected:
    void initializeGL();
    void resizeGL(int width, int height);
    void paintGL();


private:
    void display_cb(void);
    void DisplayOGLXErrors();
    void window_reshape();
    void pfd_init();
};

#endif // PFD_LAYER_H
