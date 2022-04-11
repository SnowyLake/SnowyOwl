using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;

public class CameraMove : MonoBehaviour
{
    public float m_MoveSpeed = 5.0f;
    public float m_ViewSensitivity = 0.2f;

    public CameraInputSystem m_InputSystem;

    private Rigidbody rb;
    public Camera mainCamera;

    void Awake()
    {
        m_InputSystem = new CameraInputSystem();
        m_InputSystem.Enable();
    }
    void Start() 
    {
        rb = GetComponent<Rigidbody>();
        Cursor.lockState = CursorLockMode.Locked;
    }

    void Update()
    {
        Movement(m_InputSystem.Camera.HorizontalMovement.ReadValue<Vector2>(), m_InputSystem.Camera.VerticalMovement.ReadValue<float>());
        View(m_InputSystem.Camera.View.ReadValue<Vector2>());
    }

    private void Movement(Vector2 horizontalMove, float verticalove)
    {
        Vector3 xHorizontal = transform.right * horizontalMove.x;
        Vector3 yHorizontal = transform.forward * horizontalMove.y;
        Vector3 vertical = transform.up * verticalove;

        Vector3 velocity = (xHorizontal + yHorizontal + vertical).normalized * m_MoveSpeed;

        if (velocity != Vector3.zero)
        {
            rb.MovePosition(rb.position + velocity * Time.deltaTime);
        }

    }
    private void View(Vector2 rotation)
    {
        Vector3 xRotation = new Vector3(-rotation.y, 0f, 0f) * m_ViewSensitivity;
        Vector3 yRotation = new Vector3(0f, rotation.x, 0f) * m_ViewSensitivity;

        rb.MoveRotation(rb.rotation * Quaternion.Euler(yRotation));
        mainCamera.transform.Rotate(xRotation);
    }
}
