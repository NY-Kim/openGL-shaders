#include "mygl.h"
#include "shaderprograms/surfaceshader.h"

void MyGL::slot_setCurrentSurfaceShaderProgram(int s)
{
    mp_progSurfaceCurrent = m_surfaceShaders[s].get();
    // initalize with shader applied
    mp_progSurfaceCurrent->setCameraPosition(m_camera.eye);
}

void MyGL::slot_setCurrentPostprocessShaderProgram(int s)
{
    mp_progPostprocessCurrent = m_postprocessShaders[s].get();
}

void MyGL::slot_setCurrentModel(int m)
{
    mp_modelCurrent = (m_models[m]).get();
}

void MyGL::slot_setCurrentMatcapTexture(int t)
{
    mp_matcapTexCurrent = (m_matcapTextures[t]).get();
    mp_matcapTexCurrent->load(0);
}
