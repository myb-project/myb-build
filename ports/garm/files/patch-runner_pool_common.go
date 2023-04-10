--- runner/pool/common.go.orig	2022-06-24 11:41:38 UTC
+++ runner/pool/common.go
@@ -193,7 +193,7 @@ func (r *basePool) AddRunner(ctx context.Context, pool
 		return errors.Wrap(err, "fetching pool")
 	}
 
-	name := fmt.Sprintf("garm-%s", uuid.New())
+	name := fmt.Sprintf("mybee-%s", uuid.New())
 
 	createParams := params.CreateInstanceParams{
 		Name:          name,
