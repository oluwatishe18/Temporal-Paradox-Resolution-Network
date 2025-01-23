;; Resolution Strategies Contract

(define-data-var strategy-counter uint u0)

(define-map resolution-strategies uint {
  creator: principal,
  paradox-id: uint,
  description: (string-utf8 500),
  quantum-signature: (buff 32),
  status: (string-ascii 20),
  votes: uint,
  created-at: uint
})

(define-public (propose-strategy (paradox-id uint) (description (string-utf8 500)) (quantum-signature (buff 32)))
  (let
      ((new-id (+ (var-get strategy-counter) u1)))
      (map-set resolution-strategies new-id {
          creator: tx-sender,
          paradox-id: paradox-id,
          description: description,
          quantum-signature: quantum-signature,
          status: "proposed",
          votes: u0,
          created-at: block-height
      })
      (var-set strategy-counter new-id)
      (ok new-id)
  )
)

(define-public (vote-strategy (strategy-id uint))
  (let
      ((strategy (unwrap! (map-get? resolution-strategies strategy-id) (err u404))))
      (ok (map-set resolution-strategies strategy-id
          (merge strategy { votes: (+ (get votes strategy) u1) })))
  )
)

(define-public (update-strategy-status (strategy-id uint) (new-status (string-ascii 20)))
  (let
      ((strategy (unwrap! (map-get? resolution-strategies strategy-id) (err u404))))
      (ok (map-set resolution-strategies strategy-id
          (merge strategy { status: new-status })))
  )
)

(define-read-only (get-strategy (strategy-id uint))
  (map-get? resolution-strategies strategy-id)
)

(define-read-only (get-strategy-count)
  (var-get strategy-counter)
)

