//Title: HSI classification - FixedPoint
//Author: Leonardo Rebello Januário

#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#include "defines.h"
#include "fileReader.h"
#include "qmath.h"

/**
 * log (base e)
 */
fixedp qlog( fixedp p_Base )
{
    fixedp w = 0;
	fixedp y = 0;
	fixedp z = 0;
	fixedp num = int2q(1);
	fixedp dec = 0;

	if ( p_Base == int2q(1) )
		return 0;

	if ( p_Base == 0 )
		return 0xffffffff;

	for ( dec=0 ; qabs( p_Base ) >= int2q(2) ; dec += int2q(1) )
		p_Base = qdiv(p_Base, QLN_E);

	p_Base -= int2q(1);
	z = p_Base;
	y = p_Base;
	w = int2q(1);

	while ( y != y + w )
	{
		z = 0 - qmul( z , p_Base );
		num += int2q(1);
		w = qdiv( z , num );
		y += w;
	}

	return y + dec;
}

/**
 * exp (e to the x)
 */
fixedp qexp(fixedp p_Base)
{
	fixedp w;
	fixedp y;
	fixedp num;

	for ( w=int2q(1), y=int2q(1), num=int2q(1) ; y != y+w ; num += int2q(1) )
	{
		w = qmul(w, qdiv(p_Base, num));
		y += w;
	}

	return y;
}

/**
 * pow
 */
fixedp qpow( fixedp p_Base, fixedp p_Power )
{
	if ( p_Base < 0 && qmod(p_Power, int2q(2)) != 0 )
		return - qexp( qmul(p_Power, qlog( -p_Base )) );
	else
		return qexp( qmul(p_Power, qlog(qabs( p_Base ))) );
}

int main(){

    clock_t start, end;
	double cpu_time_used;

    FILE *fid;
    float *sample, *bias, *kernelScale, *supportVector, *alpha, *labels;

    unsigned short int resultCode[n_classifiers] = { 0 };

    unsigned short int svSizes[] = { size1 , size2 , size3 , size4 , size5 ,
									 size6 , size7 , size8 , size9 , size10};

    float sv12[size1][n_bands], sv13[size2][n_bands], sv14[size3][n_bands], sv15[size4][n_bands],
		sv23[size5][n_bands], sv24[size6][n_bands], sv25[size7][n_bands],
		sv34[size8][n_bands], sv35[size9][n_bands], sv45[size10][n_bands];

	float* *supportVectors[n_classifiers] = { &sv12, &sv13, &sv14, &sv15,
											&sv23, &sv24, &sv25,
											&sv34, &sv35,
											&sv45 };

	char file0[24] = { "Indian_Pines/sv_12.dat" }, file1[24] = { "Indian_Pines/sv_13.dat" }, file2[24] = { "Indian_Pines/sv_14.dat" }, file3[24] = { "Indian_Pines/sv_15.dat" },
		file4[24] = { "Indian_Pines/sv_23.dat" }, file5[24] = { "Indian_Pines/sv_24.dat" }, file6[24] = { "Indian_Pines/sv_25.dat" },
		file7[24] = { "Indian_Pines/sv_34.dat" }, file8[24] = { "Indian_Pines/sv_35.dat" },
		file9[24] = { "Indian_Pines/sv_45.dat" };

	char* fileNames[] = { file0 , file1 , file2 , file3 , file4 , file5 , file6 , file7 , file8 , file9 };

	float* *alphaArrays[n_classifiers];

	char aFile0[25] = { "Indian_Pines/alpha12.dat" }, aFile1[25] = { "Indian_Pines/alpha13.dat" }, aFile2[25] = { "Indian_Pines/alpha14.dat" }, aFile3[25] = { "Indian_Pines/alpha15.dat" },
		aFile4[25] = { "Indian_Pines/alpha23.dat" }, aFile5[25] = { "Indian_Pines/alpha24.dat" }, aFile6[25] = { "Indian_Pines/alpha25.dat" },
		aFile7[25] = { "Indian_Pines/alpha34.dat" }, aFile8[25] = { "Indian_Pines/alpha35.dat" },
		aFile9[25] = { "Indian_Pines/alpha45.dat" };

	char* alphaFiles[] = { aFile0 , aFile1 , aFile2 , aFile3 , aFile4 , aFile5 , aFile6 , aFile7 , aFile8 , aFile9  };

	float* *labelArrays[n_classifiers];

	char labelFile0[27] = { "Indian_Pines/svLabel01.dat" }, labelFile1[27] = { "Indian_Pines/svLabel02.dat" }, labelFile2[27] = { "Indian_Pines/svLabel03.dat" },
		labelFile3[27] = { "Indian_Pines/svLabel04.dat" }, labelFile4[27] = { "Indian_Pines/svLabel05.dat" }, labelFile5[27] = { "Indian_Pines/svLabel06.dat" },
		labelFile6[27] = { "Indian_Pines/svLabel07.dat" }, labelFile7[27] = { "Indian_Pines/svLabel08.dat" }, labelFile8[27] = { "Indian_Pines/svLabel09.dat" },
		labelFile9[27] = { "Indian_Pines/svLabel10.dat" };

	char* labelFiles[] = { labelFile0 , labelFile1 , labelFile2 , labelFile3 , labelFile4 , labelFile5 , labelFile6 , labelFile7 ,
						  labelFile8 , labelFile9 };

    unsigned short int idCodes[n_classes][n_classifiers] = { {1,1,1,1,0,0,0,0,0,0},
                                                             {0,0,0,0,1,1,1,0,0,0},
                                                             {0,0,0,0,0,0,0,1,1,0},
                                                             {0,0,0,0,0,0,0,0,0,1},
                                                             {0,0,0,0,0,0,0,0,0,0} };

	unsigned short int maskCodes[n_classes][n_classifiers] = { {1,1,1,1,0,0,0,0,0,0},
                                                               {1,0,0,0,1,1,1,0,0,0},
                                                               {0,1,0,0,1,0,0,1,1,0},
                                                               {0,0,1,0,0,1,0,1,0,1},
                                                               {0,0,0,1,0,0,1,0,1,1} };

    //Read SVs and Alpha data
    for (int x = 0; x < n_classifiers; x++)
	{
		fid = fopen(fileNames[x], "rb");
		sample = readFile(fid);
		mountMatrix(supportVectors[x], svSizes[x], sample);
		fclose(fid);

		fid = fopen(alphaFiles[x], "rb");
		alphaArrays[x] = readFile(fid);
		fclose(fid);

		fid = fopen(labelFiles[x], "rb");
		labelArrays[x] = readFile(fid);
		fclose(fid);
	}

    //Read sample data ------------------------------------------------------------------
    fid = fopen("Indian_Pines/stdPixelBruno2.dat", "rb");
    sample = readFile(fid);
    fclose(fid);
    //-----------------------------------------------------------------------------------

    //Read bias data --------------------------------------------------------------------
    fid = fopen("Indian_Pines/bias.dat", "rb");
    bias = readFile(fid);
    fclose(fid);
    //-----------------------------------------------------------------------------------

    //Read kernelScale ------------------------------------------------------------------
    fid = fopen("Indian_Pines/kernelScale.dat", "rb");
    kernelScale = readFile(fid);
    fclose(fid);
    //-----------------------------------------------------------------------------------

    fixedp fixedp_sample[n_classifiers * n_bands];
    fixedp fixedp_bias[n_classifiers];
    fixedp fixedp_kernelScale[n_classifiers];
    fixedp fixedp_supportVector[5532 * n_bands];
    fixedp fixedp_alpha[5532];
    fixedp fixedp_labels[5532];

    unsigned short int band_index = 0;
    unsigned short int sample_index = 0;
    unsigned int supp_index = 0;
    unsigned short int sv_index = 0;

    alpha = alphaArrays;
    labels = labelArrays;
    supportVector = supportVectors;

    printf("\n\n");

    for (int i = 0; i < n_classifiers; i++){

        fixedp_bias[i] = float2q(bias[i]);

        fixedp_kernelScale[i] = float2q(kernelScale[i]);

        for (int j = 0; j < n_bands; j++){

            fixedp_sample[sample_index] = float2q(sample[i + band_index]);

            printf("%f,", sample[i + band_index]);

            band_index += 10;
            sample_index += 1;
        }

        band_index = 0;

        for (int k = 0; k < svSizes[i]; k++){

            fixedp_alpha[sv_index] = float2q(alpha[sv_index]);
            fixedp_labels[sv_index] = float2q(labels[sv_index]);

            sv_index += 1;

            for(int l = 0; l < n_bands; l++){

                fixedp_supportVector[supp_index] = float2q(supportVector[supp_index]);

                supp_index += 1;
            }
        }
    }

    fixedp fixedp_euclideanOP;
    fixedp fixedp_accumulator01 = int2q(0);
    fixedp fixedp_accumulator02 = int2q(0);
    fixedp fixedp_alpha_label;
    fixedp fixedp_neg = float2q(-1);
    fixedp fixedp_power2 = int2q(2);

    band_index = 0;
    supp_index = 0;
    sv_index = 0;

    //start = clock();

    for (int i = 0; i < n_classifiers; i++){
        for (int j = 0; j < svSizes[i]; j++){
            for (int k = 0; k < n_bands; k++){

                fixedp_euclideanOP = qsub(fixedp_sample[k + band_index], fixedp_supportVector[supp_index]);

                fixedp_accumulator01 = qadd(fixedp_accumulator01, qmul(fixedp_euclideanOP, fixedp_euclideanOP));

                supp_index += 1;
            }

            fixedp_accumulator01 = qmul(qdiv(fixedp_accumulator01, qpow(fixedp_kernelScale[i], fixedp_power2)), fixedp_neg);

            if (fixedp_accumulator01 > int2q(0)) //Redundancy required by library failure
                fixedp_accumulator01 = qmul(fixedp_accumulator01, fixedp_neg);

            fixedp_accumulator01 = qexp(fixedp_accumulator01);

            if (qabs(fixedp_accumulator01) > int2q(1)) //Redundancy required by library failure
                fixedp_accumulator01 = int2q(0);

            fixedp_alpha_label = qmul(fixedp_alpha[sv_index], fixedp_labels[sv_index]);

            fixedp_accumulator01 = qmul(fixedp_accumulator01, fixedp_alpha_label);

            fixedp_accumulator02 = qadd(fixedp_accumulator02, fixedp_accumulator01);

            fixedp_accumulator01 = int2q(0);

            sv_index += 1;
        }

        fixedp_accumulator02 = qadd(fixedp_accumulator02, fixedp_bias[i]);

        if (fixedp_accumulator02 < int2q(0))
            resultCode[i] = 1;
        else
            resultCode[i] = 0;

        printf("%f\n", q2float(fixedp_accumulator02));

        fixedp_accumulator02 = float2q(0);

        band_index += 10; //Verificar -> Bruno
    }

    printf("\nFixed Result code: ");
	for (int i = 0; i < n_classifiers; i++)
	{
		printf("%d,", resultCode[i]);
	}

	printf("\n");

		//Hamming distance
	unsigned short int nOnes = n_classifiers;
	unsigned short int count = 0;
	unsigned short int pixelClass;

	for (int i = 0; i < n_classes; i++)
	{
		count = 0;

		for (int j = 0; j < n_classifiers; j++)
		{
			if (resultCode[j] != idCodes[i][j])
			{
				if (maskCodes[i][j] == 1)
				{
					count++;
				}
			}
		}

		if (count < nOnes)
		{
			nOnes = count;
			pixelClass = i + 1;
		}
	}

	end = clock();
	cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;
	printf("\nTotal time taken by CPU: %lf\n\n", cpu_time_used);

	printf("\nPixel classified to class: %d", pixelClass);
	printf("\n");

	return 0;
}
