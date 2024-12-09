package transaction

import (
	domain "backEnd/internal/domain"
	pkgResource "backEnd/pkg/resource"
	"context"

	"go.uber.org/dig"
)

type Controller struct {
	dig.In

	Domain   domain.Domain
	Resource pkgResource.Resource
}

// GetTransactions implements StrictServerInterface.
func (c *Controller) GetTransactions(ctx context.Context, request GetTransactionsRequestObject) (GetTransactionsResponseObject, error) {
	panic("unimplemented")
}

// GetTransactionsByCategory implements StrictServerInterface.
func (c *Controller) GetTransactionsByCategory(ctx context.Context, request GetTransactionsByCategoryRequestObject) (GetTransactionsByCategoryResponseObject, error) {
	panic("unimplemented")
}

var _ StrictServerInterface = (*Controller)(nil)
