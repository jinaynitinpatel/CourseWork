#include <stdio.h>
#include <math.h>
#include <X11/Xlib.h>

#define DIM 512

/******************************************************************/
/* This structure contains the coordinates of a box drawn with    */
/* the left mouse button on the image window.                     */
/* roi.x , roi.y  - left upper corner's coordinates               */
/* roi.width , roi.height - width and height of the box           */
/******************************************************************/
extern XRectangle roi;

void edge_detect(int template[3][3], unsigned char img[DIM][DIM], int row, int col, unsigned char final_img[DIM][DIM]){
    int filter_img[DIM][DIM];
    for(int i=0; i<row-2; i++){
        for(int j=0; j<col-2; j++){
            filter_img[i][j] = 0;
            for(int k=0; k<3; k++){
                for(int l=0; l<3; l++){
                    filter_img[i][j] = filter_img[i][j] + img[i+k][j+l]*template[k][l];
                }
            }
        }
    }

    //Normalize

    int min = 999;
    int max = -999;
    for(int i=0; i<row-2; i++){
        for(int j=0; j<col-2; j++){
            if(filter_img[i][j] < min){

                min = filter_img[i][j];
            }
            if(filter_img[i][j] > max){

                max = filter_img[i][j];
            }
        }
    }
    for(int i=0; i<row-2; i++){
        for(int j=0; j<col-2; j++){
            if (min != max){
                final_img[i][j] = (unsigned char)((filter_img[i][j]-min)* 255/(max-min));
            }
            else{
                final_img[i][j] = 0;
            }
        }
    }

}

/******************************************************************/
/* Main processing routine. This is called upon pressing the      */
/* Process button of the interface.                               */
/* image  - the original greyscale image                          */
/* size   - the actual size of the image                          */
/* proc_image - the image representation resulting from the       */
/*              processing. This will be displayed upon return    */
/*              from this function.                               */
/******************************************************************/
void process_image(image, size, proc_img)
unsigned char image[DIM][DIM];
int size[2];
unsigned char proc_img[DIM][DIM];
{

    int prewit_vert[3][3] = {{-1, 0, 1}, {-1, 0, 1}, {-1, 0, 1}};
    int prewit_hor[3][3] = {{-1, -1, -1}, {0, 0, 0}, {1, 1, 1}};
    int prewit_majdiag[3][3] = {{0, -1, -1}, {1, 0, -1}, {1, 1, 0}};
    int prewit_mindiag[3][3] = {{-1, -1, 0}, {-1, 0, 1}, {0, 1, 1}};
    edge_detect(prewit_mindiag, image, size[0], size[1], proc_img);
}
