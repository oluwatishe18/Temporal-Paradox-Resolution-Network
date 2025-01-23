;; Paradox Detection and Reporting Contract

(define-data-var paradox-counter uint u0)

(define-map paradoxes uint {
  reporter: principal,
  timeline: (string-ascii 50),
  description: (string-utf8 500),
  severity: uint,
  status: (string-ascii 20),
  detection-time: uint
})

(define-public (report-paradox (timeline (string-ascii 50)) (description (string-utf8 500)) (severity uint))
  (let
      ((new-id (+ (var-get paradox-counter) u1)))
      (map-set paradoxes new-id {
          reporter: tx-sender,
          timeline: timeline,
          description: description,
          severity: severity,
          status: "reported",
          detection-time: block-height
      })
      (var-set paradox-counter new-id)
      (ok new-id)
  )
)

(define-public (update-paradox-status (paradox-id uint) (new-status (string-ascii 20)))
  (let
      ((paradox (unwrap! (map-get? paradoxes paradox-id) (err u404))))
      (ok (map-set paradoxes paradox-id
          (merge paradox { status: new-status })))
  )
)

(define-read-only (get-paradox (paradox-id uint))
  (map-get? paradoxes paradox-id)
)

(define-read-only (get-paradox-count)
  (var-get paradox-counter)
)

