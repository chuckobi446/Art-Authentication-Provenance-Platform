;; Fractional Ownership Contract

(define-fungible-token fraction)

(define-map artwork-fractions uint {
    total-fractions: uint,
    price-per-fraction: uint,
    available-fractions: uint,
    owner: principal
})

(define-map fraction-owners (tuple (artwork-id uint) (owner principal)) uint)

(define-public (create-fractions (artwork-id uint) (total-fractions uint) (price-per-fraction uint))
    (let
        ((existing-fractions (map-get? artwork-fractions artwork-id)))
        (asserts! (is-none existing-fractions) (err u403))
        (map-set artwork-fractions artwork-id {
            total-fractions: total-fractions,
            price-per-fraction: price-per-fraction,
            available-fractions: total-fractions,
            owner: tx-sender
        })
        (ok true)))

(define-public (buy-fraction (artwork-id uint) (fraction-count uint))
    (let
        ((fractions (unwrap! (map-get? artwork-fractions artwork-id) (err u404)))
         (total-price (* (get price-per-fraction fractions) fraction-count)))
        (asserts! (<= fraction-count (get available-fractions fractions)) (err u400))
        (try! (stx-transfer? total-price tx-sender (get owner fractions)))
        (try! (ft-mint? fraction fraction-count tx-sender))
        (map-set artwork-fractions artwork-id
            (merge fractions {available-fractions: (- (get available-fractions fractions) fraction-count)}))
        (map-set fraction-owners {artwork-id: artwork-id, owner: tx-sender}
            (+ (default-to u0 (map-get? fraction-owners {artwork-id: artwork-id, owner: tx-sender})) fraction-count))
        (ok true)))

(define-read-only (get-fraction-balance (artwork-id uint) (owner principal))
    (ok (default-to u0 (map-get? fraction-owners {artwork-id: artwork-id, owner: owner}))))

(define-read-only (get-artwork-fractions (artwork-id uint))
    (ok (unwrap! (map-get? artwork-fractions artwork-id) (err u404))))
