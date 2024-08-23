// Jinaykumar Patel
// 1001937580
// PART 2 //
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

double square(double a){
    return a*a;
}

double mean(double matrix[roi.height][roi.width]){
    double sum = 0;
    
    for(int i=0; i<roi.height; i++){
        for(int j=0; j<roi.width; j++){
            
            sum = sum + matrix[i][j];
        }
    }
    
    return sum/(roi.height*roi.width);
}

double std_deviation(double matrix[roi.height][roi.width]){
    double temp[roi.height][roi.width];
    double m = mean(matrix);
    for(int i=0; i<roi.height; i++){
        for(int j=0; j<roi.width; j++){
            
            temp[i][j] = square(matrix[i][j] - m);
        }
    }
    return sqrt(mean(temp));
}

void select_region(unsigned char image[DIM][DIM], int row, int col, int x_selected, int y_selected, double img_region[roi.height][roi.width]){
    
    for(int i=0; i<roi.height-2; i++){
        for(int j=0; j<roi.width-2; j++){
            if(x_selected+i >= row)
                img_region[i][j] = 0.0;
            
            else if(y_selected+j >= col)
                img_region[i][j] = 0.0;
            
            else
                img_region[i][j] = image[x_selected+i][y_selected+j];
        }
    }
    
}

double convolution_calculation(double img_region[roi.height][roi.width], double template[roi.height][roi.width]){
    double template_mean = mean(template);
    double template_std_deviation = std_deviation(template);
    double img_region_mean = mean(img_region);
    double img_region_std_deviation = std_deviation(img_region);
    
    double sum = 0;
    
    for(int i=0; i<roi.height; i++){
        for(int j=0; j<roi.width; j++){
            sum = sum + (img_region[i][j]-img_region_mean)*(template[i][j]-template_mean)/(img_region_std_deviation*template_std_deviation);
        }
    }
    return sum/(roi.height*roi.width);
}

void temp_match_normalized_convolution(unsigned char image[DIM][DIM], int row, int col, unsigned char final_img[DIM][DIM])
{
    double subfinal_img[DIM][DIM];
    double template[roi.height][roi.width];
    for(int i=0; i<roi.height; i++){
        for(int j=0; j<roi.width; j++){
            template[i][j] = (double)image[roi.x+i][roi.y + j];
        }
    }
    
    for(int i=0; i<row; i++){
        for(int j=0; j<col; j++){
            double img_region[roi.height][roi.width];
            select_region(image, row, col, i, j, img_region);
            subfinal_img[i][j] = convolution_calculation(img_region, template);
            
        }
    }
    
    //Normalize
    double min = 9999.0;
    double max = -9999.0;
    for(int i=0; i<row; i++){
        for(int j=0; j<col; j++){
            if(subfinal_img[i][j] < min){

                min = subfinal_img[i][j];
            }
            if(subfinal_img[i][j] > max){
      
                max = subfinal_img[i][j];
            }
        }
    }
    for(int i=0; i<row-2; i++){
        for(int j=0; j<col-2; j++){
            if (min != max){
                final_img[i][j] = (unsigned char)((subfinal_img[i][j]-min) * 255/(max-min));
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
    temp_match_normalized_convolution(image, size[0], size[1], proc_img);
}
