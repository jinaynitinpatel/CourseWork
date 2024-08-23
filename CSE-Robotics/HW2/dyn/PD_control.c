#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#ifndef M_PI
#define M_PI 3.1415927
#endif

int UTA_ID = 1001937580;


double PD_control(theta, theta_dot, theta_ref, theta_dot_ref)
double theta, theta_dot, theta_ref, theta_dot_ref;
{

  //double tau = 10;
  double b = 0.815009;
  double I = 10/216.0;
  //double b = f/theta_dot;

  while (theta > 2*M_PI){
    theta = theta - 2*M_PI;
  }

  while (theta < 0){
    theta = theta + 2*M_PI;
  }

  printf("%f %f\n", theta, theta_dot);
  double K_p = 100.0;
  double K_d = 2*sqrt(K_p);
  double control_force = I*(K_p*(theta_ref-theta) + K_d*(theta_dot_ref-theta_dot)) + b*theta_dot + 2.205195*cos(theta);

  return control_force;
}

