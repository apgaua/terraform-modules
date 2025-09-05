resource "aws_eks_addon" "main" {
  count                      = length(var.cluster[0].addons)
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = var.cluster[0].addons[count.index].name
  addon_version               = var.cluster[0].addons[count.index].version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  tags                        = merge({ "kubernetes.io/cluster/${var.project_name}" = "shared" }, var.default_tags)
  depends_on                  = [aws_eks_access_entry.nodes]
}