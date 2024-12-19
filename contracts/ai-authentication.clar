;; Art NFT Contract

(define-non-fungible-token art-nft uint)

(define-map artwork-data uint {
    artist: principal,
    title: (string-utf8 256),
    description: (string-utf8 1024),
    creation-date: uint,
    image-url: (string-utf8 256),
    is-physical: bool
})

(define-data-var artwork-counter uint u0)

(define-public (mint-artwork (title (string-utf8 256)) (description (string-utf8 1024)) (creation-date uint) (image-url (string-utf8 256)) (is-physical bool))
    (let
        ((artwork-id (+ (var-get artwork-counter) u1)))
        (try! (nft-mint? art-nft artwork-id tx-sender))
        (map-set artwork-data artwork-id {
            artist: tx-sender,
            title: title,
            description: description,
            creation-date: creation-date,
            image-url: image-url,
            is-physical: is-physical
        })
        (var-set artwork-counter artwork-id)
        (ok artwork-id)))

(define-public (transfer-artwork (artwork-id uint) (recipient principal))
    (try! (nft-transfer? art-nft artwork-id tx-sender recipient))
    (ok true))

(define-read-only (get-artwork-data (artwork-id uint))
    (ok (unwrap! (map-get? artwork-data artwork-id) (err u404))))

(define-read-only (get-artwork-owner (artwork-id uint))
    (ok (nft-get-owner? art-nft artwork-id)))

