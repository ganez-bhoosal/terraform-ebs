data "aws_iam_policy_document" "default" {
  statement {
    sid = "1"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:ListObject"
    ]

    resources = [
      "arn:aws:s3:::*"
    ]
  }
}

data "aws_iam_policy_document" "ec2" {
  statement {
    sid = "1"

    actions = [
      "ec2:*"
    ]

    resources = [
      "arn:aws:ec2:::*"
    ]
  }

}

resource "aws_iam_policy" "default" {
  name   = "terraform-ebs"
  policy = "${data.aws_iam_policy_document.default.json}"
}

resource "aws_iam_policy" "ec2" {
  name   = "terraform-ebs"
  policy = "${data.aws_iam_policy_document.ec2.json}"
}

resource "aws_iam_role" "default" {
  name = "terraform-ebs"
  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
EOF
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = "${aws_iam_role.default.name}"
  policy_arn = ["${aws_iam_policy.default.arn}", "${aws_iam_policy.ec2.arn}"]
}

resource "aws_iam_instance_profile" "default" {
  name = "terraform-ebs"
  role = "${aws_iam_role.default.name}"
}
