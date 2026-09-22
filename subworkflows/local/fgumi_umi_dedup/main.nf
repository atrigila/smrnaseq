//
// Handle UMI reads with fgumi
//

include { FGUMI_EXTRACT } from '../../../modules/nf-core/fgumi/extract/main'
include { FGUMI_SORT    } from '../../../modules/nf-core/fgumi/sort/main'
include { FGUMI_DEDUP   } from '../../../modules/nf-core/fgumi/dedup/main'
include { FGUMI_FASTQ   } from '../../../modules/nf-core/fgumi/fastq/main'

workflow FGUMI_UMI_DEDUP {
    take:
    reads // channel: [ val(meta), [ reads ] ]

    main:
    ch_versions = channel.empty()

    ch_reads_with_library = reads.map { meta, reads_files -> [ meta, reads_files, meta.id ] }

    FGUMI_EXTRACT ( ch_reads_with_library )
    FGUMI_SORT    ( FGUMI_EXTRACT.out.bam )
    FGUMI_DEDUP   ( FGUMI_SORT.out.bam )
    FGUMI_FASTQ   ( FGUMI_EXTRACT.out.bam )

    emit:
    reads     = FGUMI_FASTQ.out.reads
    metrics   = FGUMI_DEDUP.out.metrics
    histogram = FGUMI_DEDUP.out.histogram
    versions  = ch_versions
}
