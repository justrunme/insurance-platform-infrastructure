import React from 'react';
import { useParams } from 'react-router-dom';
import {
  Typography,
  Card,
  CardContent,
  Box,
  Chip,
  Grid,
  List,
  ListItem,
  ListItemText,
  Divider,
} from '@mui/material';

const ClaimDetail = () => {
  const { id } = useParams();

  // Mock data - in real app, this would come from API
  const claimData = {
    1: {
      claimNumber: 'CLM-2024-001',
      type: 'Auto Insurance',
      status: 'pending',
      amount: '$5,000',
      date: '2024-01-15',
      description: 'Vehicle collision on Highway 101',
      policyNumber: 'POL-AUTO-2023-456',
      adjuster: 'John Smith',
      timeline: [
        { date: '2024-01-15', event: 'Claim filed', status: 'completed' },
        { date: '2024-01-16', event: 'Initial review', status: 'completed' },
        { date: '2024-01-17', event: 'Documentation requested', status: 'completed' },
        { date: '2024-01-18', event: 'Under investigation', status: 'pending' },
        { date: 'TBD', event: 'Final decision', status: 'upcoming' }
      ]
    },
    2: {
      claimNumber: 'CLM-2024-002',
      type: 'Home Insurance',
      status: 'approved',
      amount: '$2,500',
      date: '2024-01-10',
      description: 'Water damage in basement',
      policyNumber: 'POL-HOME-2023-789',
      adjuster: 'Sarah Johnson',
      timeline: [
        { date: '2024-01-10', event: 'Claim filed', status: 'completed' },
        { date: '2024-01-11', event: 'Initial review', status: 'completed' },
        { date: '2024-01-12', event: 'Site inspection', status: 'completed' },
        { date: '2024-01-13', event: 'Approved for payment', status: 'completed' },
        { date: '2024-01-14', event: 'Payment processed', status: 'completed' }
      ]
    }
  };

  const claim = claimData[id] || claimData['1']; // Fallback to first claim

  const getStatusColor = (status) => {
    switch (status) {
      case 'approved': return 'success';
      case 'pending': return 'warning';
      case 'rejected': return 'error';
      default: return 'default';
    }
  };

  const getTimelineColor = (status) => {
    switch (status) {
      case 'completed': return 'success';
      case 'pending': return 'warning';
      case 'upcoming': return 'default';
      default: return 'default';
    }
  };

  return (
    <Box>
      <Typography variant="h4" gutterBottom>
        Claim Details
      </Typography>

      <Grid container spacing={3}>
        {/* Main Claim Information */}
        <Grid item xs={12} md={8}>
          <Card sx={{ mb: 3 }}>
            <CardContent>
              <Box display="flex" justifyContent="space-between" alignItems="center" sx={{ mb: 2 }}>
                <Typography variant="h5">
                  {claim.claimNumber}
                </Typography>
                <Chip 
                  label={claim.status} 
                  color={getStatusColor(claim.status)}
                />
              </Box>

              <Grid container spacing={2}>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="textSecondary">
                    Claim Type
                  </Typography>
                  <Typography variant="body1" sx={{ mb: 2 }}>
                    {claim.type}
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="textSecondary">
                    Claim Amount
                  </Typography>
                  <Typography variant="h6" color="primary" sx={{ mb: 2 }}>
                    {claim.amount}
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="textSecondary">
                    Date Filed
                  </Typography>
                  <Typography variant="body1" sx={{ mb: 2 }}>
                    {claim.date}
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="textSecondary">
                    Policy Number
                  </Typography>
                  <Typography variant="body1" sx={{ mb: 2 }}>
                    {claim.policyNumber}
                  </Typography>
                </Grid>
                <Grid item xs={12}>
                  <Typography variant="subtitle2" color="textSecondary">
                    Description
                  </Typography>
                  <Typography variant="body1">
                    {claim.description}
                  </Typography>
                </Grid>
              </Grid>
            </CardContent>
          </Card>

          {/* Claim Timeline */}
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Claim Timeline
              </Typography>
              <List>
                {claim.timeline.map((item, index) => (
                  <React.Fragment key={index}>
                    <ListItem sx={{ px: 0 }}>
                      <ListItemText
                        primary={
                          <Box display="flex" justifyContent="space-between" alignItems="center">
                            <Typography variant="body1">
                              {item.event}
                            </Typography>
                            <Chip 
                              label={item.status} 
                              color={getTimelineColor(item.status)}
                              size="small"
                            />
                          </Box>
                        }
                        secondary={item.date}
                      />
                    </ListItem>
                    {index < claim.timeline.length - 1 && <Divider />}
                  </React.Fragment>
                ))}
              </List>
            </CardContent>
          </Card>
        </Grid>

        {/* Sidebar Information */}
        <Grid item xs={12} md={4}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Contact Information
              </Typography>
              
              <Typography variant="subtitle2" color="textSecondary">
                Assigned Adjuster
              </Typography>
              <Typography variant="body1" sx={{ mb: 2 }}>
                {claim.adjuster}
              </Typography>

              <Typography variant="subtitle2" color="textSecondary">
                Contact Number
              </Typography>
              <Typography variant="body1" sx={{ mb: 2 }}>
                1-800-INSURANCE
              </Typography>

              <Typography variant="subtitle2" color="textSecondary">
                Email Support
              </Typography>
              <Typography variant="body1">
                support@insurance.com
              </Typography>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};

export default ClaimDetail; 