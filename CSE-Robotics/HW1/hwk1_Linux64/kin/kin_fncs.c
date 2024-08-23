#include <stdio.h>
#include <math.h>
#include "gsl/gsl_blas.h"
#include "gsl/gsl_matrix.h"

#ifndef M_PI
#define M_PI 3.1415927
#endif

//fwd_kin(theta, x);
//double *theta;
//double x[3];
//{
//}

/*int main(void){
    
    double data[] = {1,2,3,4};
    gsl_matrix_view t = gsl_matrix_view_array(data,2,2);
    gsl_matrix *m = gsl_matrix_alloc(2,2);

    printf("%f\n", gsl_matrix_get(&t.matrix, 1, 0));
    return 0;
}*/
void x_rot(gsl_matrix * m, double theta){
    double m1[] = {1, 0, 0, 0,
                    0, cos(theta), -sin(theta), 0,
                    0, sin(theta), cos(theta), 0,
                    0, 0, 0, 1};
                gsl_matrix_view t1 = gsl_matrix_view_array(m1,4,4);
                gsl_matrix_memcpy(m, &t1.matrix);
}
void y_rot(gsl_matrix * m, double theta){
    double m1[] = {cos(theta), 0, sin(theta), 0,
                    0, 1, 0, 0,
                    -sin(theta), 0, cos(theta), 0,
                    0, 0, 0, 1};
                gsl_matrix_view t1 = gsl_matrix_view_array(m1,4,4);
                gsl_matrix_memcpy(m, &t1.matrix);
}
void z_rot(gsl_matrix * m, double theta){
    double m1[] = {cos(theta), -sin(theta), 0, 0,
                    sin(theta), cos(theta), 0, 0,
                    0, 0, 1, 0,
                    0, 0, 0, 1};
                gsl_matrix_view t1 = gsl_matrix_view_array(m1,4,4);
                gsl_matrix_memcpy(m, &t1.matrix);
}
void pos(gsl_matrix * m, double x_[3]){
    double m1[] = {1, 0, 0, x_[0],
                    0, 1, 0, x_[1],
                    0, 0, 1, x_[2],
                    0, 0, 0, 1};
                gsl_matrix_view t1 = gsl_matrix_view_array(m1,4,4);
                gsl_matrix_memcpy(m, &t1.matrix);
}

fwd_kin(theta, x)
double *theta;
double x[3];
{
    gsl_matrix * prod1 = gsl_matrix_alloc (4, 4);
    gsl_matrix * prod2 = gsl_matrix_alloc (4, 4);
    gsl_matrix * prod3 = gsl_matrix_alloc (4, 4);
    gsl_matrix * prod4 = gsl_matrix_alloc (4, 4);
    gsl_matrix * prod5 = gsl_matrix_alloc (4, 4);
    gsl_matrix * prod6 = gsl_matrix_alloc (4, 4);
    gsl_matrix * prod7 = gsl_matrix_alloc (4, 4);
    gsl_matrix * prod8 = gsl_matrix_alloc (4, 4);
    gsl_matrix * prod9 = gsl_matrix_alloc (4, 4);
    gsl_matrix * prod10 = gsl_matrix_alloc (4, 4);
    gsl_matrix * R0 = gsl_matrix_alloc (4, 4);
    gsl_matrix * R1 = gsl_matrix_alloc (4, 4);
    gsl_matrix * R2 = gsl_matrix_alloc (4, 4);
    gsl_matrix * R3 = gsl_matrix_alloc (4, 4);
    gsl_matrix * R4 = gsl_matrix_alloc (4, 4);
    gsl_matrix * R5 = gsl_matrix_alloc (4, 4);
    gsl_matrix * R6 = gsl_matrix_alloc (4, 4);
    gsl_matrix * R7 = gsl_matrix_alloc (4, 4);
    gsl_matrix * R8 = gsl_matrix_alloc (4, 4);
    gsl_matrix * R9 = gsl_matrix_alloc (4, 4);
    gsl_matrix * R10 = gsl_matrix_alloc (4, 4);

    double l0[] = {0,0,0.25};
    double l1[] = {0.2,0,0};
    double l2[] = {0.2,0,0};
    double l3[] = {0.15,0,0};
    double d1[] = {0,0.04,0};
    double d2[] = {0,0,0.04};

    gsl_vector * pv = gsl_vector_alloc(4);

    z_rot(R0, theta[0]);
    pos(R1, l0);
    y_rot(R2, theta[1]);
    pos(R3, l1);
    y_rot(R4, theta[2]);
    pos(R5, d1);
    pos(R6, l2);
    y_rot(R7, theta[3]);
    pos(R8, d2);
    x_rot(R9, theta[4]);
    pos(R10, l3);
    gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, R9, R10, 0.0, prod1);
    gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, R8, prod1, 0.0, prod2);
    gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, R7, prod2, 0.0, prod3);
    gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, R6, prod3, 0.0, prod4);
    gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, R5, prod4, 0.0, prod5);
    gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, R4, prod5, 0.0, prod6);
    gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, R3, prod6, 0.0, prod7);
    gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, R2, prod7, 0.0, prod8);
    gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, R1, prod8, 0.0, prod9);
    gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, R0, prod9, 0.0, prod10);
    
    gsl_matrix_get_col(pv,prod10,3);

    for (int i=0; i<3; i++){
    x[i] = gsl_vector_get(pv,i);

}
    return 0;
}

double square(double a){
	return a*a;
}

inv_kin(x, theta)
double *x;
double theta[6];
{
	double l0 = 0.25;
	double l1 = 0.2;
	double l2 = 0.2;
	double l3 = 0.15;
	double d1 = 0.04;
	double d2 = 0.04;

	double z = x[2]+l3-l0;

	double gamma = atan2(x[1],x[0]);
	double sbet = d1/(sqrt(square(x[0])+square(x[1])));
	double cbet = sqrt(square(x[0])+square(x[1])-square(d1))/sqrt(square(x[0])+square(x[1]));
	double bet = atan2(sbet,cbet);
	theta[0] = gamma-bet;
	double r_xy = sqrt(square(x[0]-d2*cos(theta[0])+d1*sin(theta[0]))+square(x[1]-d2*sin(theta[0])-d1*cos(theta[0])));
	theta[2] = acos((-square(l1)-square(l2)+square(r_xy)+square(z))/(2*l1*l2));
	double alpha = acos((square(l1)-square(l2)+square(r_xy)+square(z))/(2*l1*sqrt(square(r_xy)+square(z))));
	double gamma_new = atan2(z, r_xy);
	if(theta[2]<0){
		theta[1] = -gamma_new + alpha;	
	}
	else{
		theta[1] = -gamma_new - alpha;				
	}
	
	theta[3] = M_PI/2 - theta[1] - theta[2];
	theta[4] = 0;
	theta[5] = 0;

	return 0;
}




