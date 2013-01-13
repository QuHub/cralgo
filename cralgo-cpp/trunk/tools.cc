
/****************************************
 * These are various functions for LIF
 * **************************************/


#include "EpiG.h"




/****************************************
 * Matrix Multiplication using CBLAS libs
 * **************************************/
void cblasMatrixProduct(qGate *A, qGate *B, qGate *C) {
	int val = A->valuedness;
	int rows = int(pow((float) val, (float) A->numIO));
	cuComplex alpha = make_cuFloatComplex(1, 0);
	cuComplex beta = make_cuFloatComplex(0, 0);
	cblas_cgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, rows, rows, rows, &alpha, A->gateMatrix1, rows, B->gateMatrix1, rows, &beta, C->gateMatrix1, rows);
	C->numIO = A->numIO;
}


/****************************************
 * Fills the content of a matrix size resultnum to I
 * **************************************/
void zeroMatrix(qGate *A, int resultnum) {
	A -> numIO = resultnum;
	A -> Cost = 1;
	int val = A->valuedness;
	int maxcount = (int(pow(pow((float) val, (float) A->numIO),2)));
	for (int i = 0; i < maxcount; i++) {
		A->gateMatrix1[i] = make_cuFloatComplex(0, 0);
	}
}
/****************************************
 * Init a Vector to all 0
 * **************************************/
#ifdef __CUDA__
#else
void vectorInitZero(int w, cuComplex *d_Vec){
	for (int m = 0; m < w; m++)
                d_Vec[m] = make_cuFloatComplex(0, 0);
}
#endif
/****************************************
 * Dot Multiply two vectors
 * **************************************/
void vectorScalarMult(int w, cuComplex scalar, cuComplex *a_Vec, cuComplex *b_Vec){
	cuComplex result = make_cuFloatComplex(0, 0);
        for (int m = 0; m < w; m++)
                b_Vec[m] =  cuCmulf(a_Vec[m], scalar);
}
/****************************************
 * Sets the initialized gate to be the Identity gate
 * **************************************/
void initMatrix(qGate *A, int resultnum) {
	A -> numIO = resultnum;
	A -> Cost = 1;
	int val = A->valuedness;
	int rows = (int(pow((float) val, (float) A->numIO)));
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < rows; j++) {
			(i == j) ? A->gateMatrix1[i*rows+j] = make_cuFloatComplex(1, 0): A->gateMatrix1[i*rows+j] = make_cuFloatComplex(0, 0);
		}
	}
}

/****************************************
 * Creates the gate and set the appropriate parameters
 * **************************************/
void initGate(qGate *A, int resultnum, int valuedness, int cost) {
	A -> numIO = resultnum;
	int val = A->valuedness = valuedness;
	A -> Cost = cost;
	int maxcount = (int)(pow(pow((float) valuedness, (float) resultnum),2.0));
	A->gateMatrix1 = new cuComplex[maxcount];
	A->representation = new char[REPSIZE];
	A->parentA = new char[REPSIZE];
	A->parentB = new char[REPSIZE];
}

/****************************************
 * Deletes the gate matrix
 * **************************************/
void destroyGate(qGate *A){
	delete [] A->gateMatrix1;
	A->gateMatrix1 = NULL;
}

/**********************************
*RowMajor Kronecker Product
 **********************************/
void tensorProduct2(qGate *R, qGate *A, qGate *B) {
	int val = A->valuedness;
	R->valuedness = val;
	int index;
	int k = 0;
	int maxcount_a = (int(pow(pow((float) val, (float) A->numIO),2)));
	int maxcount_b = (int(pow(pow((float) val, (float) B->numIO),2)));
	int dim_a = (int(pow((float) val, (float) A->numIO)));
	int dim_b = (int(pow((float) val, (float) B->numIO)));
	int new_row_dim = (int(dim_a*dim_b));
	int p_a,d_a,p_b,d_b;
	for (int i = 0; i < maxcount_a; i++) {
		p_a = i % dim_a;
		d_a = i / dim_a;
		k = 0;
		for (int m = 0; m < maxcount_b / dim_b; m++)
		{
			for (int j = 0; j < dim_b; j++) {
				p_b = k / dim_b;
				index = (p_a*dim_b)+(d_a*dim_a*maxcount_b)+(p_b*new_row_dim)+j;
				R->gateMatrix1[index] = cuCmulf(A->gateMatrix1[i], B->gateMatrix1[k]);
				k++;
			}
		}
	}
	R->numIO = (A->numIO + B->numIO);
}
/**********************************
*Column Major Kronecker Product
 **********************************/
void tensorProduct3(qGate *R, qGate *A, qGate *B) {
	int val = A->valuedness;
	R->valuedness = val;
	int index;
	int k = 0;
	int maxcount_a = (int(pow(pow((float) val, (float) A->numIO),2)));
	int maxcount_b = (int(pow(pow((float) val, (float) B->numIO),2)));
	int dim_a = (int(pow((float) val, (float) A->numIO)));
	int dim_b = (int(pow((float) val, (float) B->numIO)));
	int new_column_dim = (int(dim_a*dim_b));
	int p_a,d_a,p_b,d_b;
	for (int i = 0; i < maxcount_a; i++) {
		p_a = i % dim_a;
		d_a = i / dim_a;
		k = 0;
		for (int m = 0; m < maxcount_b / dim_b; m++)
		{
			for (int j = 0; j < dim_b; j++) {
				p_b = k / dim_b;
				index = (p_a*dim_b)+(d_a*dim_b*new_column_dim)+(p_b*new_column_dim)+j;
				R->gateMatrix1[index] = cuCmulf(A->gateMatrix1[i], B->gateMatrix1[k]);
				k++;
			}
		}
	}
	R->numIO = (A->numIO + B->numIO);
	R->representation[0] = 'f';
	R->representation[1] = 'f';
	R->representation[2] = 'f';
	R->representation[REPSIZE] = '\0';
	R->my_string = "";
	R->Cost = 1;
}


/**********************************
 * substract two matrices, returns first argument
 **********************************/
qGate* matrixSubstr(qGate *A, qGate *B) {
	int val = A->valuedness;
	int maxcount = (int(pow(pow((float) val, (float) A->numIO),2)));
	for (int i = 0; i < maxcount; i++) {
		A->gateMatrix1[i] = cuCsubf(A->gateMatrix1[i], B->gateMatrix1[i]);
	}
	return A;
}


short sign(float c){
	if (c >= 0 )
		return 1;
	else return -1;
}


/**********************************
* accepts a decimal integer and returns a binary coded string
* only for unsigned values
 **********************************/

void dec2bin(long decimal, char *binary, int radix)
{
	int k = 0, n = 0;
	int neg_flag = 0;
	int remain;
	int old_decimal; // for test
	char temp[80];
	// take care of negative input

	if (decimal < 0)
	{
		decimal = -decimal;
		neg_flag = 1;
	}
	do
	{
		old_decimal = decimal; // for test
		remain = decimal % 2;
		// whittle down the decimal number
		decimal = decimal / 2;
		// this is a test to show the action
		//printf("%d/2 = %d remainder = %d\n", old_decimal, decimal, remain);
		// converts digit 0 or 1 to character '0' or '1'
		temp[k++] = remain + '0';
	} while (decimal > 0);

//	if (neg_flag)
//		temp[k++] = '-'; // add - sign
//	else
//		temp[k++] = ' '; // space

	// reverse the spelling
	if (k < radix)
		while (n < (radix - k))
			binary[n++] = '0';
	while (k >= 0)
		binary[n++] = temp[--k];

	binary[n-1] = 0; // end with NULL
}

