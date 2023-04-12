import unittest
from unittest.mock import patch, MagicMock
from app.generator import generate_password, update_secret, rotate_rds_password


class TestPasswordRotation(unittest.TestCase):

    def test_generate_password(self):
        password = generate_password(8)
        self.assertEqual(len(password), 8)

    @patch('boto3.client')
    def test_update_secret(self, mock_client):
        mock_secret = {'ARN': 'arn:aws:secretsmanager:us-east-1:123456789012:secret:example',
                       'Name': 'example', 'VersionId': 'EXAMPLE1-90ab-cdef-fedc-ba987EXAMPLE',
                       'SecretString': 'supersecret'}
        mock_client.return_value.update_secret.return_value = mock_secret

        response = update_secret('example', 'newsecret')
        self.assertEqual(response, mock_secret)

    @patch('boto3.client')
    @patch('generator.generate_password')
    def test_rotate_rds_password(self, mock_generate_password, mock_client):
        mock_generate_password.return_value = 'newpassword'
        mock_rds = MagicMock()
        mock_client.return_value = mock_rds
        mock_secret = {'ARN': 'arn:aws:secretsmanager:us-east-1:123456789012:secret:example',
                       'Name': 'example', 'VersionId': 'EXAMPLE1-90ab-cdef-fedc-ba987EXAMPLE',
                       'SecretString': 'oldpassword'}
        mock_client.return_value.get_secret_value.return_value = mock_secret

        rotate_rds_password('example', 'rds-instance')

        mock_client.return_value.get_secret_value.assert_called_once_with(SecretId='example')
        mock_rds.modify_db_instance.assert_called_once_with(DBInstanceIdentifier='rds-instance',
                                                            MasterUserPassword='newpassword',
                                                            ApplyImmediately=True)
        mock_client.return_value.update_secret.assert_called_once_with(SecretId='example',
                                                                       SecretString='newpassword')
