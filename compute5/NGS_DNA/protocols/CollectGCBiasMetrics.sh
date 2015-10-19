#MOLGENIS walltime=23:59:00 mem=6gb ppn=6


#Parameter mapping
#string stage
#string checkStage
#string picardVersion
#string gcBiasMetricsJar
#string dedupBam
#string dedupBamIdx
#string indexFile
#string collectBamMetricsPrefix
#string tempDir
#string recreateInsertSizePdfR
#string rVersion
#string capturingKit
#string seqType
#string picardJar

#Load Picard module
${stage} ${picardVersion}

#Load R module
${stage} ${rVersion}
${stage} ngs-utils
${checkStage}

makeTmpDir ${collectBamMetricsPrefix}
tmpCollectBamMetricsPrefix=${MC_tmpFile}

#Run Picard GcBiasMetrics
java -XX:ParallelGCThreads=4 -jar -Xmx4g ${EBROOTPICARD}/${picardJar} ${gcBiasMetricsJar} \
R=${indexFile} \
I=${dedupBam} \
O=${tmpCollectBamMetricsPrefix}.gc_bias_metrics \
CHART=${tmpCollectBamMetricsPrefix}.gc_bias_metrics.pdf \
VALIDATION_STRINGENCY=LENIENT \
TMP_DIR=${tempDir}

    echo -e "\nGcBiasMetrics finished succesfull. Moving temp files to final.\n\n"
    mv ${tmpCollectBamMetricsPrefix}.gc_bias_metrics ${dedupBam}.gc_bias_metrics
    mv ${tmpCollectBamMetricsPrefix}.gc_bias_metrics.pdf ${dedupBam}.gc_bias_metrics.pdf

######IS THIS STILL NEEDED, IMPROVEMENTS/UPDATES TO BE DONE?#####
#Create nicer insertsize plots if seqType is PE
#if [ "${seqType}" == "PE" ]
#then
	# Overwrite the PDFs that were just created by nicer onces:
	${recreateInsertSizePdfR} \
	--insertSizeMetrics ${dedupBam}.insert_size_metrics \
	--pdf ${dedupBam}.insert_size_histogram.pdf

#else
	# Don't do insert size analysis because seqType != "PE"

#fi