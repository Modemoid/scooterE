/*
 * MatrixKB.h
 *
 * Created: 11.09.2014 7:52:30
 *  Author: kartsev
 */ 


#ifndef MATRIXKB_H_
#define MATRIXKB_H_

#ifndef F_CPU
/* prevent compiler error by supplying a default */
# warning "F_CPU not defined for <util/delay.h>"
# define F_CPU 1000000UL
#endif

#define KBLines 4
#define KBCol 4
#define KBPort PORTD
#define KBPullUP 1
#define L1 0
#define L2 1
#define L3 2
#define L4 3
#define Col1 4
#define Col2 5








#endif /* MATRIXKB_H_ */