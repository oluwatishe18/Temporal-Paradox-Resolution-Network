;; Timeline Integrity Tracking Contract

(define-map timeline-integrity (string-ascii 50) {
  stability-index: uint,
  last-check: uint,
  paradox-count: uint,
  resolved-count: uint
})

(define-public (update-timeline-integrity (timeline (string-ascii 50)) (stability-index uint))
  (let
      ((current-data (default-to
          { stability-index: u0, last-check: u0, paradox-count: u0, resolved-count: u0 }
          (map-get? timeline-integrity timeline))))
      (ok (map-set timeline-integrity timeline
          (merge current-data {
              stability-index: stability-index,
              last-check: block-height
          })))
  )
)

(define-public (record-paradox (timeline (string-ascii 50)))
  (let
      ((current-data (unwrap! (map-get? timeline-integrity timeline) (err u404))))
      (ok (map-set timeline-integrity timeline
          (merge current-data {
              paradox-count: (+ (get paradox-count current-data) u1)
          })))
  )
)

(define-public (record-resolution (timeline (string-ascii 50)))
  (let
      ((current-data (unwrap! (map-get? timeline-integrity timeline) (err u404))))
      (ok (map-set timeline-integrity timeline
          (merge current-data {
              resolved-count: (+ (get resolved-count current-data) u1)
          })))
  )
)

(define-read-only (get-timeline-integrity (timeline (string-ascii 50)))
  (map-get? timeline-integrity timeline)
)

