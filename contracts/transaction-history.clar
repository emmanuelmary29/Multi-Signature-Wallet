;; Transaction History Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))

;; Data Variables
(define-data-var event-nonce uint u0)

;; Data Maps
(define-map events
  { event-id: uint }
  {
    event-type: (string-ascii 20),
    tx-id: (optional uint),
    signer: (optional principal),
    amount: (optional uint),
    recipient: (optional principal),
    new-required-signatures: (optional uint)
  }
)

;; Public Functions

;; Log a transaction proposal
(define-public (log-proposal (tx-id uint) (recipient principal) (amount uint))
  (let
    (
      (event-id (var-get event-nonce))
    )
    (map-set events
      { event-id: event-id }
      {
        event-type: "proposal",
        tx-id: (some tx-id),
        signer: none,
        amount: (some amount),
        recipient: (some recipient),
        new-required-signatures: none
      }
    )
    (var-set event-nonce (+ event-id u1))
    (ok event-id)
  )
)

;; Log a transaction execution
(define-public (log-execution (tx-id uint))
  (let
    (
      (event-id (var-get event-nonce))
    )
    (map-set events
      { event-id: event-id }
      {
        event-type: "execution",
        tx-id: (some tx-id),
        signer: none,
        amount: none,
        recipient: none,
        new-required-signatures: none
      }
    )
    (var-set event-nonce (+ event-id u1))
    (ok event-id)
  )
)

;; Log a signature
(define-public (log-signature (tx-id uint) (signer principal))
  (let
    (
      (event-id (var-get event-nonce))
    )
    (map-set events
      { event-id: event-id }
      {
        event-type: "signature",
        tx-id: (some tx-id),
        signer: (some signer),
        amount: none,
        recipient: none,
        new-required-signatures: none
      }
    )
    (var-set event-nonce (+ event-id u1))
    (ok event-id)
  )
)

;; Log a key addition
(define-public (log-key-addition (new-signer principal))
  (let
    (
      (event-id (var-get event-nonce))
    )
    (map-set events
      { event-id: event-id }
      {
        event-type: "key-addition",
        tx-id: none,
        signer: (some new-signer),
        amount: none,
        recipient: none,
        new-required-signatures: none
      }
    )
    (var-set event-nonce (+ event-id u1))
    (ok event-id)
  )
)

;; Log a key removal
(define-public (log-key-removal (removed-signer principal))
  (let
    (
      (event-id (var-get event-nonce))
    )
    (map-set events
      { event-id: event-id }
      {
        event-type: "key-removal",
        tx-id: none,
        signer: (some removed-signer),
        amount: none,
        recipient: none,
        new-required-signatures: none
      }
    )
    (var-set event-nonce (+ event-id u1))
    (ok event-id)
  )
)

;; Log a change in required signatures
(define-public (log-required-signatures-change (new-required uint))
  (let
    (
      (event-id (var-get event-nonce))
    )
    (map-set events
      { event-id: event-id }
      {
        event-type: "required-change",
        tx-id: none,
        signer: none,
        amount: none,
        recipient: none,
        new-required-signatures: (some new-required)
      }
    )
    (var-set event-nonce (+ event-id u1))
    (ok event-id)
  )
)

;; Read-only function to get event details
(define-read-only (get-event (event-id uint))
  (map-get? events { event-id: event-id })
)

;; Initialize the contract
(define-public (initialize-contract)
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok true)
  )
)

