#include "pfd_layer.h"
#include "iostream"
//#include "freeglut.h"
#include <PFD/gl/oglx.h>
//#include <PFD/gl/GL.h>
#include <glut.h>
#include <PFD/gl/sgl.h>
#include "specific.h"
#include "Pages/PFD_Controller_macro.h"
//#include "Pages/inital_format.h"
//#include "Pages/excitation_format.h"

extern WU_PFD_Controller CTX_PFD_Controller;
using namespace std;

pfd_layer::pfd_layer(QWidget *parent)
    :QOpenGLWidget(parent)
{
    //p_CTX_PFD_Controller = &CTX_PFD_Controller.inputs_ctx;
}

pfd_layer::~pfd_layer() {
}


void pfd_layer::initializeGL() {
    //int narg = 1;
    //char** arg_list = NULL;
    //glutInit(&narg, arg_list);
    //glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH | GLUT_STENCIL);

   // glutInitWindowSize(1100, 650);
    //glutCreateWindow("PFD");
    //QOffscreenSurface surface;
    surface.create();

   // QOpenGLContext context;
    context.setFormat(QSurfaceFormat::defaultFormat());
   // context.create();
    context.makeCurrent(&surface);

    pfd_init();
    //sglSetCurrentContext(&pfd_sgl_context);
    init_scene();
}

void pfd_layer::paintGL() {

    //makeCurrent();
    context.makeCurrent(&surface);
    //excitation_format(&CTX_PFD_Controller.inputs_ctx);
    //excitation_format(p_CTX_PFD_Controller);
    //excitation_format();
    display_cb();
     
   
    context.swapBuffers(&surface);
    update();
}

void pfd_layer::resizeGL(int width, int height) {
    //display_cb();
    //window_reshape();
    /*
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Land_vis_Status= 0;
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Sky_vis_Status = 0;

    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Land_Color = 0;  //18
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Sky_Color = 0;  //9


    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Land_Opacity = 0;
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Sky_Opacity = 0;
*/
}

void pfd_layer::pfd_init()
{
    SGLulong ul_screen_width = getW();
    SGLulong ul_screen_height = getH();
    SGLbyte* pb_texture_buffer = glob_tub_texture_buffer;
    //SGLulong ul_texture_max_width = SGL_TEXTURE_MAX_WIDTH;
   // SGLulong ul_texture_max_height = SGL_TEXTURE_MAX_HEIGHT;

    lParameters.ul_screen_width = ul_screen_width;
    lParameters.ul_screen_height = ul_screen_height;
    lParameters.pb_texture_buffer = pb_texture_buffer;
    lParameters.ul_texture_max_width = SGL_TEXTURE_MAX_WIDTH;
    lParameters.ul_texture_max_height = SGL_TEXTURE_MAX_HEIGHT;
    lParameters.p_texture_attrib = glob_texture_attrib;
    lParameters.ul_number_of_textures = WIDGET_LIB_MAX_TEXTURES;
    lParameters.p_gradient_attrib = 0;
    lParameters.ul_number_of_gradients = 0UL;

    sglInit(&pfd_sgl_context, &lParameters);

    sglColorPointerf(getColorTable(), getColorTableSize());

    sglSetRenderMode(SGL_RAW_OPENGL_LINES);

    sglLineWidthPointerf(getLineWidthTable(), getLineWidthTableSize());

    sglLineStipplePointer(getLineStippleTable(), getLineStippleTableSize());

    sgluLoadFonts(getFontTable());

    //glShadeModel(GL_FLAT);

    glErrorStatus = glGetError();
    if (glErrorStatus != GL_NO_ERROR) {
        printf("Error %d raised during OGLX initialization\n\n", glErrorStatus);
    }

}

void pfd_layer::window_reshape()
{

    sglViewport(0, 0, getW(), getH());
    sglOrtho(0, (float)(getW() * getRatioX()), 0, (float)(getH() * getRatioY()));
    glErrorStatus = glGetError();
    if (glErrorStatus != GL_NO_ERROR) {
        printf("\nError %d raised during OGLX reset\n\n", glErrorStatus);
    }

}

void pfd_layer::DisplayOGLXErrors()
{

    static SGLulong loc_errors_number = 0;
    SGLulong loc_last_errors_number = 0;
    SGLulong loc_errors[SGL_ERROR_MAX][2];
    SGLbyte loc_b_status = sglGetErrors((SGLulong*)loc_errors, &loc_last_errors_number);

    if (loc_last_errors_number != loc_errors_number) {
        loc_errors_number = loc_last_errors_number;
        loc_b_status = sglGetErrors((SGLulong*)loc_errors, &loc_last_errors_number);

        if (loc_b_status != SGL_NO_ERROR) {
            printf("Number of OGLX stored errors: %d.\n", (int)loc_errors_number);

        }
        else {
            printf("No OGLX error.\n");
        }
    }

}

void pfd_layer::display_cb(void)
{
    excitation_format();
    /*
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Land_vis_Status= 1;
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Sky_vis_Status = 1;

    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Land_Color = 18;  //18
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Sky_Color = 9;  //9


    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Land_Opacity = 170;
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Sky_Opacity = 170;
*/

    glClear(GL_COLOR_BUFFER_BIT);
    window_reshape();
    draw_scene();
    glErrorStatus = glGetError();
    if (glErrorStatus != GL_NO_ERROR) {
        printf("\nError %d raised during scene rendering\n\n", glErrorStatus);
    }

    //glutSwapBuffers();
    //glFlush();
    DisplayOGLXErrors();

}



