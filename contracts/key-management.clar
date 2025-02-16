;; Key Management Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-already-authorized (err u101))
(define-constant err-not-authorized (err u102))
(define-constant err-invalid-required-signatures (err u103))

;; Data Variables
(define-data-var required-signatures uint u2)

;; Data Maps
(define-map authorized-signers principal bool)

;; Public Functions

;; Add a new authorized signer
(define-public (add-authorized-signer (new-signer principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (is-none (map-get? authorized-signers new-signer)) err-already-authorized)
    (map-set authorized-signers new-signer true)
    (ok true)
  )
)

;; Remove an authorized signer
(define-public (remove-authorized-signer (signer principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (default-to false (map-get? authorized-signers signer)) err-not-authorized)
    (map-delete authorized-signers signer)
    (ok true)
  )
)

;; Change the required number of signatures
(define-public (change-required-signatures (new-required uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> new-required u0) err-invalid-required-signatures)
    (var-set required-signatures new-required)
    (ok true)
  )
)

;; Read-only function to check if a principal is an authorized signer
(define-read-only (is-authorized (signer principal))
  (default-to false (map-get? authorized-signers signer))
)

;; Read-only function to get the required number of signatures
(define-read-only (get-required-signatures)
  (var-get required-signatures)
)


;; Initialize the contract
(define-public (initialize-contract (initial-signer principal) (initial-required uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set authorized-signers initial-signer true)
    (var-set required-signatures initial-required)
    (ok true)
  )
)

