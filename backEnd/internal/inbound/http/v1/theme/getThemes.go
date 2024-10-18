package theme

import (
	"context"
	"fmt"
)

// GetThemes implements StrictServerInterface.
func (c *Controller) GetThemes(ctx context.Context, request GetThemesRequestObject) (GetThemesResponseObject, error) {
	a := "hi"
	fmt.Println(a)
	
	return GetThemesdefaultJSONResponse{}, nil
}